def generate_create_table(df, table_name, primary_key=None, foreign_keys=None):
    """
    df: DataFrame base
    table_name: nombre de la tabla
    primary_key: str o list[str] con columna(s) que son PK
    foreign_keys: dict con {columna: (tabla_referencia, columna_referencia)}
    """
    dtype_map = {
        'int64': 'INTEGER',
        'float64': 'FLOAT',
        'object': 'VARCHAR(50)',
        'bool': 'BOOLEAN',
        'datetime64[ns]': 'DATETIME'
    }

    columns = []
    for col, dtype in df.dtypes.items():
        sql_type = dtype_map.get(str(dtype), 'TEXT')
        col_def = f"    {col} {sql_type}"
        columns.append(col_def)

    if primary_key:
        if isinstance(primary_key, str):
            pk = f"    PRIMARY KEY ({primary_key})"
        else:
            pk = f"    PRIMARY KEY ({', '.join(primary_key)})"
        columns.append(pk)

    if foreign_keys:
        for col, (ref_table, ref_col) in foreign_keys.items():
            fk = f"    FOREIGN KEY ({col}) REFERENCES {ref_table}({ref_col})"
            columns.append(fk)

    columns_str = ",\n".join(columns)
    return f"CREATE TABLE IF NOT EXISTS {table_name} (\n{columns_str}\n);"
