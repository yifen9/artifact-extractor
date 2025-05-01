# artifact-extractor

A GitHub Action to download and extract a GitHub Actions artifact.  
Supports nested `artifact.tar` produced by `upload-artifact@v4`.

## Inputs

- `name` (required): Name of the artifact to download and extract.
- `path` (optional, default `build`): Directory to extract into.

## Example

```yaml
jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - name: Extract Pages artifact
        uses: yifen9/artifact-extractor@v1
        with:
          name: github-pages
          path: build
