if [ "$#" -ne 3 ]
then
echo "Error: this script requires 3 inputs"
echo "Usage: bash scripts/01_qc_and_trimming.sh INPUT_DIR OUTPUT_DIR THREADS"
exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"
THREADS="$3"

echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Threads: $THREADS"

if [ ! -d "$INPUT_DIR" ]
then
echo "Error: the input directory does not exist: $INPUT_DIR"
exit 1
fi

mkdir -p "$OUTPUT_DIR"

for R1 in "$INPUT_DIR"/*_S*_R1_001.fastq.gz
do
R2="${R1/_R1_/_R2_}"

if [ ! -f "$R2" ]
then
echo "Error: the matching R2 paired end-file not found: $R2"
exit 1
fi

echo "R1: $R1"
echo "R2: $R2"
done

FASTQC_RAW_DIR="$OUTPUT_DIR/fastqc_raw"
mkdir -p "$FASTQC_RAW_DIR"

