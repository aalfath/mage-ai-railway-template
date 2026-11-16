# Mage AI for Railway: the official image, pinned by version and digest.
# To update: change the tag and digest below, add a CHANGELOG.md entry, test, merge to main.
FROM mageai/mageai:0.9.80@sha256:73c8e808070ef55ffe263544809197820f38ca621349b5a8ed7d6366cb861cc8 AS upstream

# Flatten the upstream image into one layer. Its later layers downgrade numpy
# (2.2.6 -> 1.26.4) by deleting files, and on Railway those deleted numpy 2 files
# reappeared at runtime, so scipy/sklearn failed to import and Mage crash-looped
# ("All ufuncs must have type numpy.ufunc"). A single layer has nothing to resurrect.
FROM scratch
COPY --from=upstream / /

# Same runtime settings as the upstream image.
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=C.UTF-8 \
    PYTHON_VERSION=3.10.22 \
    MAGE_DATA_DIR=/home/src/mage_data \
    PYTHONPATH=:/home/src
WORKDIR /home/src

COPY --chmod=755 railway-start.sh /app/railway-start.sh

EXPOSE 6789
CMD ["/app/railway-start.sh"]
