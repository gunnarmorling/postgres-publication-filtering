# Postgres Publication Filtering

A demo of using column lists and row filters from Postgres 15 with Debezium 

## Set-up

Launch Postgres, Debezium, etc.:

```bash
docker-compose up --build
```

Create a publication:

```bash
docker run --tty --rm -i \
    --network postgres-publication-filtering_default \
    quay.io/debezium/tooling:1.2 \
    bash -c 'pgcli postgresql://postgresuser:postgrespw@postgres:5432/postgresdb'

# Within pgcli
SET search_path TO inventory;

CREATE PUBLICATION inventory_publication FOR TABLE products WHERE (quantity < 10)
```

Register the connector:

```bash
# with kcctl
kcctl apply -f postgres-connector.json

# alternatively, with curl
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @inventory-connector.json
```

## Data Changes

Observe change events in Kafka:

```bash
docker run --tty --rm \
     --network postgres-publication-filtering_default \
     quay.io/debezium/tooling:1.2 \
     kafkacat -b kafka:9092 -C -o beginning -q \
     -t dbserver1.inventory.products | jq '.payload | { op, ts_ms, after }'
```

Perform changes in pgcli:

```sql
INSERT INTO products
VALUES (DEFAULT, 'deck chair', 'A cozy wooden deck chair', 15.7, 7),
       (DEFAULT, 'paint', 'A bucket of white paint', 5.0, 15),
       (DEFAULT, 'lamp', 'A green library style lamp', 4.8, 3);

UPDATE products SET quantity = 6 WHERE NAME = 'deck chair';
UPDATE products SET quantity = 14 WHERE NAME = 'paint';
UPDATE products SET quantity = 9 WHERE NAME = 'paint';
UPDATE products SET quantity = 11 WHERE NAME = 'lamp';

DELETE FROMproducts WHERE NAME = 'lamp';
DELETE FROMproducts WHERE NAME = 'deck chair';
```

## Source

The source of this project is located in the [postgres-publication-filtering](https://github.com/gunnarmorling/postgres-publication-filtering) repository on GitHub.

## License

This software is provided under the Apache License, version 2.
