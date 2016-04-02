# Jupyter Notebook Docker Image

Dockerfile for a useable notebook with several extensions

## Usage

```
docker run -ti -p 8888:8888 think/notebook
```
This provides the notebook on 0.0.0.0:8888.
Just the examples will be available.

To add own content start it like this:
```
docker run -ti -p 8888:8888 -v /directory_with_own_content:/notebook think/notebook
```
