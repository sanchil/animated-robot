import sys
import pandas as pd
import argparse


def writeSignal(
    dataFile: str, startTime: str, endTime: str, targetColumn: str, signalValue: str
) -> pd.DataFrame:
    """
    Filter a DataFrame by datetime range and update a column.

    Args:
        dataFile: Path to the input CSV file.
        startTime: Start time (YYYY-MM-DD HH:MM:SS).
        endTime: End time (YYYY-MM-DD HH:MM:SS).
        targetColumn: Name of the column to update.
        signalValue: Value to assign to the target column.

    Returns:
        Updated DataFrame.

    Raises:
        ValueError: If arguments or data are invalid.
        FileNotFoundError: If input file doesn't exist.
        pd.errors.EmptyDataError: If CSV is empty.
    """

    # Load the CSV file
    df = pd.read_csv(dataFile)

    # Ensure the datetime column is in datetime format
    df["DateTime"] = pd.to_datetime(df["DateTime"])

    # Define the date and time range criteria
    start_datetime = pd.to_datetime(startTime)
    end_datetime = pd.to_datetime(endTime)

    # Filter rows based on the datetime range
    mask = (df["DateTime"] >= start_datetime) & (df["DateTime"] <= end_datetime)

    # Assign a value to the target column for the filtered rows
    df.loc[mask, targetColumn] = signalValue

    df.to_csv(dataFile, index=False)

    # Display the updated dataframe (optional)
    # print(", ".join(df.columns))
    print(df)

    return df


if __name__ == "__main__":

    # command line
    # python modify_csv.py --inp_file="dataset/NEWDATA_TEST.csv" --stime="2025.06.04 19:19:00" --etime="2025.06.04 19:19:00" --updt_col=ORDER --sig_val="BUY"

    parser = argparse.ArgumentParser(
        description="Filter a DataFrame by numeric range and update a column."
    )
    parser.add_argument(
        "--inp_file", type=str, required=True, help="Path to the input CSV file"
    )
    parser.add_argument(
        "--stime", type=str, required=True, help="start time YYYY-MM-DD HH:MM:SS"
    )
    parser.add_argument(
        "--etime", type=str, required=True, help="end_time YYYY-MM-DD HH:MM:SS"
    )
    parser.add_argument(
        "--updt_col", type=str, required=True, help="Name of the column to update"
    )
    parser.add_argument(
        "--sig_val",
        type=str,
        required=True,
        help="Signal value to assign to the update column",
    )

    args = parser.parse_args()

    dataFile = args.inp_file
    startTime = args.stime
    endTime = args.etime
    targetColumn = args.updt_col
    signalValue = args.sig_val

    writeSignal(dataFile, startTime, endTime, targetColumn, signalValue)
