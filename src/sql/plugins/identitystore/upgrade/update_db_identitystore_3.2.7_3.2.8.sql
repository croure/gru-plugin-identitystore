-- Create new table identity_account_history
CREATE TABLE identitystore_identity_account_history (
  connection_id varchar(100) NOT NULL,
  id_identity   int NOT NULL REFERENCES identitystore_identity(id_identity),
  creation_date timestamp(3) default CURRENT_TIMESTAMP NOT NULL,
  deletion_date timestamp(3) default CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (connection_id, id_identity, creation_date)
);
CREATE INDEX identitystore_identity_account_history_connection_id ON identitystore_identity_account_history (lower(connection_id::text));
CREATE INDEX identitystore_identity_account_history_id_identity ON identitystore_identity_account_history (id_identity);

-- Rebuild the GUID periods of each identity from its GUID change history (single pass on the history table)
WITH guid_changes AS (
    SELECT i.id_identity,
           i.date_create,
           i.connection_id AS current_guid,
           NULLIF(NULLIF(NULLIF(h.metadata->>'old_guid', ''), 'null'), 'NULL') AS old_guid,
           NULLIF(NULLIF(NULLIF(h.metadata->>'new_guid', ''), 'null'), 'NULL') AS new_guid,
           h.modification_date
    FROM identitystore_identity_history h
        JOIN identitystore_identity i ON i.customer_id = h.customer_id
    WHERE h.change_type = 1
      AND h.metadata->>'new_guid' IS NOT NULL
), ordered_changes AS (
    SELECT *,
           row_number( ) OVER w AS change_rank,
           lead( modification_date ) OVER w AS next_change_date
    FROM guid_changes
    WINDOW w AS ( PARTITION BY id_identity ORDER BY modification_date )
)
INSERT INTO identitystore_identity_account_history (connection_id, id_identity, creation_date, deletion_date)
-- GUID held before the first recorded change : from the identity creation to the first change
SELECT old_guid, id_identity, date_create, modification_date
FROM ordered_changes
WHERE change_rank = 1 AND old_guid IS NOT NULL
UNION ALL
-- GUID set by each change : until the next change, except the current GUID
SELECT new_guid, id_identity, modification_date, COALESCE( next_change_date, CURRENT_TIMESTAMP )
FROM ordered_changes
WHERE new_guid IS NOT NULL
  AND NOT ( next_change_date IS NULL AND lower( new_guid ) = lower( current_guid ) );