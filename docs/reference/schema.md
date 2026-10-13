# API views and schema

The existing `api-schema/` folder contains the SQL view definitions exposed in
the Fabric GraphQL API. It is maintained in the repository but was not included
in the supplied ZIP; keep it when updating the documentation.

Use these definitions to understand exposed columns, joins, filters and derived
values. They are useful when investigating how a returned value is produced.

SQL view definitions are not a GraphQL schema export. The developer portal's
published GraphQL schema describes the callable fields, relationships, argument
names, variable types and pagination objects. Consult it when writing a query.

Consumers call `https://api.humanitarianaction.info/graphql/v1` with their subscription key.
The view files are reference material, not a separate access route.

When an exposed view changes, review the affected query examples and data rules.
Test the query against the published API before documenting the change.
