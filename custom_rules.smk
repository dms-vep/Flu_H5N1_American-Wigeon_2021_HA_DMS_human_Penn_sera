"""Custom rules used in the ``snakemake`` pipeline.

This file is included by the pipeline ``Snakefile``.

"""


rule nt_changes_to_codon:
    """Annotate how nucleotide changes to codon required for each amino-acid mutation."""
    input:
        natural_geneseq="data/American_Wigeon_H5N1_HA_EPI2709137.fa",
        site_numbering_map=config["site_numbering_map"],
        pacbio_amplicon=config["pacbio_amplicon"],
    output:
        annotations=config["mutation_annotations"],
    log:
        notebook="results/logs/nt_changes_to_codon.ipynb"
    conda:
        os.path.join(config["pipeline_path"], "environment.yml")
    notebook:
        "analysis_notebooks/nt_changes_to_codon.py.ipynb"


rule process_SA26_improvement:
    """Improvement of entry in 2,6 cells: positive difference and positive 2,6 entry.""" 
    input:
        csv="results/func_effect_diffs/SA26_vs_SA23_low-sera_entry_diffs.csv",
    output:
        csv="results/processed_results/increased_SA26_usage.csv",
    log:
        "results/logs/process_SA26_improvement.txt",
    conda:
        os.path.join(config["pipeline_path"], "environment.yml")
    script:
        "scripts/process_SA26_improvement.py"

# Files (Jupyter notebooks, HTML plots, or CSVs) that you want included in
# the HTML docs should be added to the nested dict `docs`:
docs["Additional files"] = {
    "HA site numbering": {
        "CSV converting among different protein numbering schemes":
            config["site_numbering_map"],
    },    
}
