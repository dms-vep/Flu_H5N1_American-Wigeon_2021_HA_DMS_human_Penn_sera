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


rule configure_dms_viz_human_sera:
    """Configure a JSON file for `dms-viz` for the human sera"""
    input:
        phenotypes_csv="results/summaries/phenotypes.csv",
        per_antibody_escape_csv="results/summaries/human_sera_escape_per_antibody_escape.csv",
        site_numbering_map=config["site_numbering_map"],
        nb="analysis_notebooks/configure_dms_viz_human_sera.ipynb",
    output:
        dms_viz_json="results/dms-viz/dms-viz_human_sera.json",
        dms_viz_sitemap="results/dms-viz/sitemap_human_sera.csv",
        dms_viz_phenotypes="results/dms-viz/phenotypes_human_sera.csv",
        pdb_file="results/dms-viz/pdb_file_human_sera.pdb",
        nb="results/notebooks/configure_dms_viz_human_sera.ipynb",
    params:
        dms_viz_subdir=lambda _, output: os.path.dirname(output.dms_viz_json),
        pdb_id="4kwm",
    log:
        "results/logs/configure_dms_viz_human_sera.txt",
    conda:
        "envs/dms-viz.yml"
    shell:
        """
        papermill {input.nb} {output.nb} \
            -p phenotypes_csv {input.phenotypes_csv} \
            -p per_antibody_escape_csv {input.per_antibody_escape_csv} \
            -p site_numbering_map {input.site_numbering_map} \
            -p dms_viz_json {output.dms_viz_json} \
            -p dms_viz_sitemap {output.dms_viz_sitemap} \
            -p dms_viz_phenotypes {output.dms_viz_phenotypes} \
            -p pdb_file {output.pdb_file} \
            -p dms_viz_subdir {params.dms_viz_subdir} \
            -p pdb_id {params.pdb_id} \
            &> {log}
        """

# Files (Jupyter notebooks, HTML plots, or CSVs) that you want included in
# the HTML docs should be added to the nested dict `docs`:
docs["Additional files"] = {
    "HA site numbering": {
        "CSV converting among different protein numbering schemes":
            config["site_numbering_map"],
    },
}

other_target_files.append(rules.configure_dms_viz_human_sera.output.dms_viz_json)

