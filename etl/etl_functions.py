import requests
import json
import pandas as pd
from pathlib import Path
from typing import Union
import ast
import urllib
from sqlalchemy import create_engine
from typing import List, Optional

def _safe_save(df: pd.DataFrame, path: Path) -> None:
    """
    If the file exists, remove it first so we always create a fresh one.
    Then write the DataFrame to CSV with UTF-8 encoding.
    """
    if path.exists():
        path.unlink(missing_ok=True)
    df.to_csv(path, index=False, encoding="utf-8")




def extract(url: str, file_path: Union[str, Path]) -> pd.DataFrame:
    """
    Fetch JSON data from the given URL, derive the resource name from the URL,
    and save the flattened list as ``<resource>_raw.csv`` under the specified folder.

    Parameters
    ----------
    url : str
        Full endpoint URL (e.g. ``"https://dummyjson.com/products"``).  
        The last path segment is used as the dictionary key to extract the list of records.
    file_path : str | pathlib.Path
        Directory in which the CSV file will be saved.  
        Intermediate directories are created if they do not exist.

    Returns
    -------
    pandas.DataFrame
        The normalized DataFrame produced from the list of records found under
        the derived key in the JSON response.
    
    Example
    -------
    extract("https://dummyjson.com/products", "raw_data")
    -> creates raw_data/products_raw.csv
    """
    folder = Path(file_path)
    folder.mkdir(parents=True, exist_ok=True)

    resource = url.rstrip("/").split("/")[-1]
    csv_path = folder / f"{resource}_raw.csv"

    all_records = []

    # first page to get total
    first_url = f"{url.rstrip('/')}?limit=0&skip=0"
    total = requests.get(first_url, timeout=30).json()["total"]

    limit = 100  # max allowed by DummyJSON
    skip = 0
    while skip < total:
        page_url = f"{url.rstrip('/')}?limit={limit}&skip={skip}"
        resp = requests.get(page_url, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        all_records.extend(data[resource])
        skip += limit

    df = pd.json_normalize(all_records)
    _safe_save(df, csv_path)
    return df


def convert_columns_to_json(df, columns):
    for col in columns:
        df[col] = df[col].apply(json.dumps)
    return df


def transform_products(df: pd.DataFrame, out_dir: str = "processed") -> pd.DataFrame:
    """
    Clean products_raw.csv:
      - Derive 'subcategory' from the 2nd (or 1st) tag.
      - Expand all images into image_1, image_2, image_3, ...
      - Drop original 'tags' and 'images' columns.
    Returns the cleaned DataFrame and writes products_cleaned.csv.
    """
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)


    # --- subcategory ---------------------------------------------------------
    def pick_sub(tags_str: str) -> Optional[str]:
        try:
            tags = ast.literal_eval(tags_str)
            return tags[1] if len(tags) > 1 else (tags[0] if tags else None)
        except Exception:
            return None
    df["subcategory"] = df["tags"].apply(pick_sub)

    # --- images --------------------------------------------------------------
    # Find max number of images to determine how many image_N columns we need
    def safe_len(img_str: str) -> int:
        try:
            return len(ast.literal_eval(img_str))
        except Exception:
            return 0

    max_imgs = df["images"].apply(safe_len).max()
    # Create empty columns up front to guarantee order even if no row uses them
    for i in range(1, max_imgs + 1):
        df[f"image_{i}"] = None

    def split_all_images(img_str: str) -> List[Optional[str]]:
        try:
            imgs = ast.literal_eval(img_str)
            # Pad with None so that the Series has always max_imgs elements
            return imgs + [None] * (max_imgs - len(imgs))
        except Exception:
            return [None] * max_imgs

    # Apply and assign
    img_cols = [f"image_{i}" for i in range(1, max_imgs + 1)]
    df[img_cols] = pd.DataFrame(
        df["images"].apply(split_all_images).tolist(),
        index=df.index
    )

    # --- capitalize category & subcategory -----------------------------------
    for col in ["category", "subcategory"]:
        if col in df.columns:
            df[col] = df[col].str.title()


    # Drop original columns
    df = df.drop(columns=["tags", "images"])

    # --- column order --------------------------------------------------------
    # Build the final order dynamically, including however many image_N columns exist
    fixed_cols = [
        "id", "title", "description", "category", "subcategory",
        "price", "discountPercentage", "rating", "stock",
        "brand", "sku", "weight",
        "warrantyInformation", "shippingInformation", "availabilityStatus",
        "returnPolicy", "minimumOrderQuantity"
    ]
    image_cols_ordered = [c for c in img_cols if c in df.columns]
    remaining_cols = [
        "thumbnail",
        "dimensions.width", "dimensions.height", "dimensions.depth",
        "meta.createdAt", "meta.updatedAt", "meta.barcode", "meta.qrCode"
    ]
    # Ensure we only include columns that actually exist
    final_cols = (
        fixed_cols +
        image_cols_ordered +
        [c for c in remaining_cols if c in df.columns]
    )
    df = df[final_cols]

    _safe_save(df, out_dir / "products_cleaned.csv")
    return df



def transform_carts(df: pd.DataFrame, out_dir: str = "processed") -> pd.DataFrame:
    """
    Flatten carts_raw.csv:
      - Explode 'products' list into individual rows.
      - Prefix every column coming from the products dict with 'products_'.
      - Add synthetic 'row_id' (1-based).
    Returns the flattened DataFrame and writes carts_exploded.csv.
    """
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    df["products"] = df["products"].apply(ast.literal_eval)

    exploded = df.explode("products").reset_index(drop=True)
    products_norm = pd.json_normalize(exploded["products"])

    # Prefix every products column
    products_norm = products_norm.add_prefix("product_")

    cleaned = exploded.drop(columns=["products"]).join(products_norm)

    _safe_save(cleaned, out_dir / "carts_cleaned.csv")
    return cleaned



def create_reviews_table(df: pd.DataFrame, out_dir: str = "processed") -> pd.DataFrame:
    """
    Build reviews.csv from products_raw.csv:
      - Extract the 'reviews' list for each product.
      - Add 'product_id' and unique 'review_id'.
    Returns the reviews DataFrame and writes reviews.csv.
    """
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

   
    df["reviews"] = df["reviews"].apply(ast.literal_eval)

    exploded = df[["id", "reviews"]].explode("reviews").reset_index(drop=True)
    reviews_norm = pd.json_normalize(exploded["reviews"])
    reviews_df = reviews_norm.copy()
    reviews_df.insert(0, "product_id", exploded["id"])
    reviews_df.insert(0, "review_id", range(1, len(reviews_df) + 1))

    _safe_save(reviews_df, out_dir / "reviews.csv")
    return reviews_df





def load(df: pd.DataFrame,
         table_name: str,
         schema: str = "dbo",
         server: str = "localhost",
         database: str = "dummydb",
         column_mapping: dict = None) -> None:
    """
    Load a pandas DataFrame to SQL Server table.
    Optionally map DataFrame columns to SQL table columns.
    """
    import urllib
    from sqlalchemy import create_engine

    if column_mapping:
        df = df.rename(columns=column_mapping)

    params = urllib.parse.quote_plus(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={server};"
        f"DATABASE={database};"
        "Trusted_Connection=yes;"
    )
    engine = create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)

    df.to_sql(table_name,
              con=engine,
              schema=schema,
              if_exists="replace",
              index=False)

    print(f"✅ {len(df)} rows loaded into {schema}.{table_name}")
