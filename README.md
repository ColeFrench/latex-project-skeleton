# LaTeX project skeleton
This repo provides a basic environment in which you can start writing LaTeX. Its main purpose is for personal use, so my setup choices (in [settings.tex](./settings.tex)) may reflect that.

## Usage
[Create your own repo from this template](https://docs.github.com/articles/creating-a-repository-from-a-template/), clone and `cd` into it, then follow the next steps to get set up.

### Prerequisites
For consistent usage, this project requires Docker. You'll need to install it and start up the Docker Engine. Then, run
```sh
docker build -t tectonic .
```
To install more packages (e.g., fonts), add on to the `# Install extra packages` line in the [Dockerfile](./Dockerfile) and run the above command again.

### Building
[LaTeX Workshop](https://github.com/James-Yu/LaTeX-Workshop) is recommended. It will automatically rebuild a `.tex` file when you save it. Or, you can run this each time you want to rebuild:
```sh
docker run --mount=type=bind,source="$(pwd)",target=/home/user \
    tectonic --synctex --keep-logs <filename.tex>
```
