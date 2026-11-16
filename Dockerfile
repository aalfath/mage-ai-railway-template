# Mage AI for Railway: the official image, pinned by version and digest.
# To update: change the tag and digest below, add a CHANGELOG.md entry, test, merge to main.
FROM mageai/mageai:0.9.80@sha256:73c8e808070ef55ffe263544809197820f38ca621349b5a8ed7d6366cb861cc8

COPY railway-start.sh /app/railway-start.sh
RUN chmod +x /app/railway-start.sh

EXPOSE 6789
CMD ["/app/railway-start.sh"]
