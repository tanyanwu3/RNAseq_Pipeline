# Input confirmation
# The script requires 3 inputs: input_dir, ouput_dir, and threads
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

# is Conda program present?
if command -v conda >/dev/null
then
echo "Conda program found"
else
echo "Conda program not found"
OS="$(uname -s)"
ARCH="$(uname -m)"

# Is miniconda supported on this system?
if [ "$OS" = "Linux" ] && [ "$ARCH" = "x86_64" ]
then
MINICONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"

elif [ "$OS" = "Linux" ] && { [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; }
then
MINICONDA_INSTALLER="Miniconda3-latest-Linux-aarch64.sh"

else
echo "Error: unsupported system: $OS $ARCH"
exit 1
fi

MINICONDA_URL="https://repo.anaconda.com/miniconda/$MINICONDA_INSTALLER"
echo "Miniconda URL: $MINICONDA_URL"

# if Conda isn't available, download with curl
if command -v curl >/dev/null
then
echo "curl program found"

# Download the Miniconda installer file with curl
curl -fL "$MINICONDA_URL" -o "$HOME/$MINICONDA_INSTALLER"

# if curl isn't available, download with wget
elif command -v wget >/dev/null
then
echo "wget program found"

# Download the Miniconda installer file with wget
wget "$MINICONDA_URL" -O "$HOME/$MINICONDA_INSTALLER"

else
echo "Error: curl or wget required to download Miniconda"
exit 1
fi

# Confirm the Miniconda installer file was downloaded
if [ ! -f "$HOME/$MINICONDA_INSTALLER" ]
then
echo "Error: Miniconda installer download was not successful"
exit 1
fi

fi

# Create output directory
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

