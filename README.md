MicrogliaMorphology
================

#### *An ImageJ macro for microglia morphology analysis*

**Created**: 15 June, 2023 by Jenn Kim  
**Last updated**: 16 October, 2023

## Welcome to MicrogliaMorphology!

MicrogliaMorphology is a user-friendly ImageJ macro that offers a
semi-automated approach to characterize 27 morphology features from
hundreds to thousands of individual microglia cells.

#### If you are using this tool, please cite the following publications:

-   Insert manuscript link
-   [Quantifying Microglia Morphology from Photomicrographs of
    Immunohistochemistry Prepared Tissue Using
    ImageJ](https://www.jove.com/t/57648/quantifying-microglia-morphology-from-photomicrographs)

## Before you begin

### Install FIJI and plugins required for MicrogliaMorphology:

-   [FIJI/ImageJ](https://imagej.net/software/fiji/?Downloads)
-   [BioVoxxel Toolbox](https://imagej.net/plugins/biovoxxel-toolbox)
-   [FracLac](https://imagej.nih.gov/ij/plugins/fraclac/FLHelp/Installation.htm)

### Install MicrogliaMorphology into ImageJ plugins folder and download MicrogliaMorphology_BioVoxxel script

1.  When you download and install FIJI, your app and related
    scripts/plugins will be saved into a folder called “Fiji.app”.
    Create a new directory called “MicrogliaMorphology” under:
    Fiji.app > scripts > Plugins.
2.  Save the following files from this repo (can be found in
    macros-scripts folder) into the new MicrogliaMorphology directory:

-   **MicrogliaMorphology_BioVoxxel.ijm**
-   **MicrogliaMorphology_Program.ijm**
-   **MicrogliaMorphology_ColorByCluster.ijm**

2.  Restart ImageJ
3.  MicrogliaMorphology should now appear under Plugins (at bottom of
    drop-down) in your ImageJ toolbar, under which you can find all
    three macros that you just installed. Any of them can be clicked on
    to begin their respective user prompts. They should be used in the
    order they are listed in above.

### Create the following subdirectories in a single directory for your project where you would like to save your images and analysis output, and include one representative test image (e.g., ‘Test-Iba1’):

![](./images/Example_DatasetDirectory.png)

### Some notes about MicrogliaMorphology

**Semi-automated workflow**: MicrogliaMorphology wraps around the ImageJ
plugins BioVoxxel Toolbox and FracLac, which are not compatible to call
to using the ImageJ macro language. As such, there are a few manual
steps in this protocol (Step 1, Step 5) which involve these 2 plugins.
The only other user input involves following prompts to select input
folders to call from and output folders to write to, with the option of
batch-processing input files for each step if desired. Otherwise, all
protocols, computation, and analysis described have been automated
within MicrogliaMorphology.

**Image preparation prior to MicrogliaMorphology**: When generating your
single-channel input .tiff images which contain the microglia you want
to analyze, include any important metadata tied to that image in its
title, with each descriptor separated by an underscore. For example:
“CohortName_AnimalID_Condition_Sex_BrainRegion.tiff” Formatting this way
is very important for compatibility with
[MicrogliaMorphologyR](https://github.com/ciernialab/MicrogliaMorphologyR)
functions.

**Integration with FASTMAP ImageJ Plugin** (or any other method of
tracing Regions of Interest prior to using MicrogliaMorphology): If you
are interested in a specific region of interest (ROI) within your
images, you can trace these in ImageJ prior to running
MicrogliaMorphology to characterize the microglia within those ROIs.
[FASTMAP](https://github.com/dterstege/FASTMAP) is one ImageJ tool that
you can use to align your brain images to the [Allen Brain Institute
reference mouse brain atlas](https://mouse.brain-map.org/static/atlas).
You can also manually trace any ROIs on your images. Just make sure to
save your .tif files so that they include the ROIs (example below), and
click the check box next to any questions such as **“Do your input
images have ROIs traced?”** that pop up in the MicrogliaMorphology
prompts. This will ensure that only the part of the image that is
contained within the ROI will be analyzed.

![](./images/ExampleROI.png)

## Video Tutorial: How to use MicrogliaMorphology

Please watch this video before proceeding to the section below, which
contains details for specific steps which are meant to help guide you to
use the tool. Most of the detail is in the video, so it is important
that you watch this prior to beginning to use MicrogliaMorphology!

[![Video](./images/VideoScreenshot.png)](https://www.youtube.com/watch?v=YhLCdlFLzk8)

## Steps in MicrogliaMorphology and how to navigate them

### 1. Determine dataset-specific parameters to use in Steps 3-4

<details>
<summary>
Determine thresholding parameters using BioVoxxel Toolbox plugin (user
input required)
</summary>

1.  Run MicrogliaMorphology_BioVoxxel script in ImageJ: *Plugins >
    MicrogliaMorphology > MicrogliaMorphology_BioxVoxxel*

2.  Use **ThresholdCheck** feature within BioVoxxel Toolbox plugin to
    interactively determine the best thresholding parameters for your
    dataset. ![](./images/BioVoxxel_ThresholdCheck.png)

    -   Click/specify the following options in the pop-up box.

    ![](./images/ThresholdCheck_options.png)

    -   ThresholdCheck is a nifty tool that helps you decide which of
        the 16 auto thresholding and 9 auto local thresholding
        parameters within ImageJ are best suited for your image set.
        Auto thresholding takes into account the entire image space when
        binarizing to distinguish background from signal, while auto
        local thresholding only takes into account smaller parts of the
        image at a time using a defined radius. You can follow these
        links to read more about [auto
        thresholding](https://imagej.net/plugins/auto-threshold)
        vs. [auto local
        thresholding](https://imagej.net/plugins/auto-local-threshold).

    -   A radius of 100 will typically work well for auto local
        thresholding microglia images, but you may need to run the
        ThresholdCheck a few times using different radius values to
        optimize the parameters to best capture fully connected, single
        microglia in your thresholded images. When ‘Quantification
        (relative)’ option is selected, the plugin will give you a
        recommended thresholding method at the end of the results file -
        this is a good starting point, but you should visually verify by
        looking through ALL of the threshold methods to determine which
        is best for your dataset: capturing as many branches as possible
        that are connected to cell bodies, while minimizing overlap
        between cells. ThresholdCheck will give you a gallery of 25
        different thresholding settings on the image you input - each
        image is color coded accordingly - from the [BioVoxxel
        website](https://imagej.net/plugins/biovoxxel-toolbox#threshold-check),
        where you can find more information in the ThresholdCheck
        feature:

    ![](./images/ThresholdCheck_colors.png)

    -   Here are some examples of under, well, and over-thresholded
        microglia:

    ![](./images/ThresholdCheck_examples.png)

    -   **Make sure to note the final thresholding parameters you choose
        for your image set as you will need to input these choices into
        MicrogliaMorphology**.

</details>

#### *MicrogliaMorphology ImageJ macro begins here*

![](./images/MicrogliaMorphology_Program.png)

MicrogliaMorphology will first prompt you to specify the thresholding
parameters that you decided on in Step 1 (which is why it is important
to write them down!):

![](./images/MicrogliaMorphology_SpecifyThresholding.png)

<details>
<summary>
Determine single-cell area range (user input required)
</summary>

In this step, you are determining the cutoff ranges (min and max) for
what is considered a single microglia cell. Use the following guidelines
when picking representative cells on both extremes:

-   **When selecting particles that are too small to be considered
    single cells:** select particles that you would consider *almost* as
    big as a single-cell, but not a single cell.
    -   **When selecting particles that are too big to be considered
        single cells:** select particles that you would consider as 2
        obviously overlapping cells.
    -   Here are examples of particles that are too small or too big to
        be considered single cells: ![](./images/CellAreaExamples.png)

After you are done determining the lower and upper bounds for cell area,
MicrogliaMorphology will provide a summary of the final thresholding and
cell area parameters that will be applied in steps 2-4. You will see a
window like this pop up before moving on to step 2:

![](./images/Example_FinalAreaThresholdParameters.png)
</details>

#### Steps 2-4 will use the final parameters that you specified within the macro such that the only user input required is to follow user prompts to specify folders to read from and write output to. You can consult the video of how to use MicrogliaMorphology at the start of this document for more information.

### 2. Threshold images adapted from [standard protocol](https://www.jove.com/t/57648/quantifying-microglia-morphology-from-photomicrographs)

### 3. Generate single-cell images

### 4. Skeleton analysis

#### *MicrogliaMorphology ImageJ macro ends here*

### 5. FracLac analysis (user input required)

<details>
<summary>
Some important notes
</summary>

1.  Run FracLac plugin: *Plugins > Fractal Analysis > FracLac*
2.  Select **BC** (box counting) in Fraclac GUI and select the following
    options (adapted from [Young et al.,
    2018](https://www.jove.com/t/57648/quantifying-microglia-morphology-from-photomicrographs),
    Section 5.5). **Make sure to select ‘lock black background’.**
    ![](./images/FracLac_options.png)
3.  Select **Batch** in Fraclac GUI and follow prompts. Load in files
    from the directory you wrote your single-cell images to in Step 4.
    </details>

## ColorByCluster feature

ColorByCluster allows you to color the microglia cells in the original
immunofluorescent .tiff images by their cluster identifications. This
macro is meant to be complimentary to the output generated using
MicrogliaMorphologyR (see [ColorByCluster
section](https://github.com/ciernialab/MicrogliaMorphologyR#colorbycluster)
in the MicrogliaMorphologyR Github repo). The ColorByCluster feature
allows you to visually validate morphological clusters and gain insight
into their spatial distribution in the brain. This macro colors
microglia in one image of interest at a time. To run this macro, you
will need the following:

-   Original immunofluorescent .tiff image that was input into
    MicrogliaMorphology
-   Thresholded .tiff image that was output by MicrogliaMorphology
-   ColorByCluster labels .csv file generated using
    [MicrogliaMorphologyR](https://github.com/ciernialab/MicrogliaMorphologyR#colorbycluster)
