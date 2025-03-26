
FROM postgres:13


ENV POSTGRES_USER=spree_user
ENV POSTGRES_PASSWORD=spree_password
ENV POSTGRES_DB=spree_production


EXPOSE 5432
