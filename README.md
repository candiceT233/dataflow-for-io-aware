# dataflow-for-io-aware

This folder is a notebook-based analysis workspace for I/O-aware workflow scheduling project.  
It contains:
- workflow I/O trace artifacts (JSON),
- aggregated tabular inputs (CSV),
- analysis notebooks (`wf*.ipynb`), and
- generated plotting outputs (PDFs).

## 1) Folder Structure

```text
dataflow-for-io-aware/
├── 1000-genome/                  # Raw 1000 Genome trace artifacts (*.json)
├── 1000genome_plots/             # Generated 1000 Genome PDF plots
├── ddmd/
│   ├── ddmd_script_order.json    # Local task ordering config
│   └── ddmd_4n_pfs_large/
│       └── 4n_pfs_t1/            # DDMD trace artifacts (*.json)
├── ddmd_plots/                   # Generated DDMD PDF plots
├── montage_plots/                # Generated Montage PDF plots
├── pyflex_plots/                 # Generated PyFLEX PDF plots
├── seismology_plots/             # Generated Seismology PDF plots
├── *.csv                         # Aggregated workflow I/O datasets
└── wf*.ipynb                     # Analysis notebooks (per workflow/use case)
```

### Top-level notebook groups

- `wf1_*` -> PyFLEX
- `wf2_*` -> 1000 Genome
- `wf3_*` -> Seismology
- `wf4_*` -> Montage
- `wf5_*` -> DDMD
- `wf6_*` -> PtychoNN
- `wf7_*` -> LLM workflow (profile analysis)

Most workflows have both:
- `*_IO_profile_analysis_*.ipynb` (profile/statistics-oriented),
- `*_IO_3d*analysis_*.ipynb` (3D/2D relationship visualization).

## 2) Usage

### Prerequisites

Use Python 3 with Jupyter and common plotting/data packages:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install jupyter pandas matplotlib seaborn numpy
```

### Quick start (recommended)

Use this workflow to run any notebook in this repo without rewriting paths each time:

1. Open a target notebook (for example `wf1_IO_profile_analysis_pyflex.ipynb`).
2. Find the config cell that defines `project_root`, `pattern_configs`, and `CURR_WF`.
3. Replace that block with the template below.
4. Set `WORKFLOW_KEY` to one of: `pyflex`, `1kgenome`, `seismology`, `montage`, `ddmd`, `ptychonn`, `llm`.
5. Run all cells.

Template config cell:

```python
from pathlib import Path
import os

project_root = Path.cwd()
WORKFLOW_KEY = "pyflex"  # change per notebook/run

pattern_configs = {
    "pyflex": {
        "csv_file_path": project_root / "summer_sam_4n_pfs_s9_tr_estimated_fixed.csv",
        "task_order_list": project_root / "pyflex_script_order.json",  # if available
        "plot_file_name": "pyflex_3d_relationship_files.pdf",
        "result_path": project_root / "pyflex_plots",
    },
    "1kgenome": {
        "csv_file_path": project_root / "par_6000_10n_nfs_ps300_tr_estimated.csv",
        "task_order_list": project_root / "1kg_script_order.json",  # if available
        "plot_file_name": "6000_3d_relationship_files.pdf",
        "result_path": project_root / "1000genome_plots",
    },
    "seismology": {
        "csv_file_path": project_root / "seismology_fixed.csv",
        "task_order_list": project_root / "seismology_script_order.json",  # if available
        "plot_file_name": "seismology_3d_relationship_files.pdf",
        "result_path": project_root / "seismology_plots",
    },
    "montage": {
        "csv_file_path": project_root / "montage_s8_tr_estimated_fixed.csv",
        "task_order_list": project_root / "montage_s8_script_order.json",  # if available
        "plot_file_name": "montage_3d_relationship_files.pdf",
        "result_path": project_root / "montage_plots",
    },
    "ddmd": {
        "csv_file_path": project_root / "ddmd_4n_pfs_large_tr_estimated.csv",
        "task_order_list": project_root / "ddmd" / "ddmd_script_order.json",
        "plot_file_name": "ddmd_3d_relationship_files.pdf",
        "result_path": project_root / "ddmd_plots",
    },
    "ptychonn": {
        "csv_file_path": project_root / "ptychonn_14m_tr_estimated.csv",
        "task_order_list": project_root / "ptychonn_script_order.json",  # if available
        "plot_file_name": "ptychonn_3d_relationship_files.pdf",
        "result_path": project_root / "ptychonn_plots",
    },
    "llm": {
        "csv_file_path": project_root / "llm_wf_2s_tr_estimated.csv",
        "task_order_list": project_root / "llm_wf_script_order.json",  # if available
        "plot_file_name": "llm_3d_relationship_files.pdf",
        "result_path": project_root / "llm_plots",
    },
}

cfg = pattern_configs[WORKFLOW_KEY]
csv_file_path = str(cfg["csv_file_path"])
task_order_file = str(cfg["task_order_list"])
plot_file_name = cfg["plot_file_name"]
result_path = str(cfg["result_path"])
os.makedirs(result_path, exist_ok=True)
```

If a notebook fails on missing `task_order_file`, either:
- add that JSON file locally, or
- temporarily point `task_order_list` to an existing JSON with compatible schema.

### Run the notebooks

From this folder:

```bash
jupyter notebook
```

Then open one of the `wf*.ipynb` notebooks and run cells.

### Important path configuration (required)

Many notebooks define a hardcoded `project_root` path from another machine (for example under `/home/.../linux_resource_detect/perf_analysis`).  
To run in this folder, update each notebook’s config cell:

1. Set `project_root` to this directory.
2. Update each `pattern_configs[*]["csv_file_path"]` and `task_order_list` to local files.
3. Keep or adjust `result_path` (for output plot folder).

Example localized config pattern:

```python
from pathlib import Path
project_root = Path.cwd()
csv_file_path = project_root / "summer_sam_4n_pfs_s9_tr_estimated_fixed.csv"
result_path = project_root / "pyflex_plots"
```

### Workflow input/output mapping

- PyFLEX: input `summer_sam_4n_pfs_s9_tr_estimated_fixed.csv` -> output `pyflex_plots/`
- 1000 Genome: input `par_6000_10n_nfs_ps300_tr_estimated.csv` -> output `1000genome_plots/`
- Seismology: input `seismology_fixed.csv` -> output `seismology_plots/`
- Montage: input `montage_s8_tr_estimated_fixed.csv` -> output `montage_plots/`
- DDMD: input `ddmd_4n_pfs_large_tr_estimated.csv` -> output `ddmd_plots/`
- PtychoNN: input `ptychonn_14m_tr_estimated.csv` -> output `ptychonn_plots/` (create if missing)
- LLM workflow: input `llm_wf_2s_tr_estimated.csv` -> output `llm_plots/` (create if missing)

### Notes

- Only `ddmd/ddmd_script_order.json` is present locally; other workflow `task_order_list` files may need to be added or pointed to local equivalents.
- Existing `*_plots/` folders already contain previously generated PDFs and can be reused or overwritten.
