# Access and permissions

Authentication proves who is calling. Authorization determines whether that
identity may execute the API and read its data source.

## People

For each approved internal user, the Fabric API owner grants access directly:

1. Open the Fabric workspace containing the GraphQL API.
2. Select the ellipsis (**...**) beside the API item.
3. Select **Manage permissions**.
4. Select **Add user** and choose the person's Microsoft Entra account.
5. Grant **Run Queries and Mutations**.

Do not add a consumer as workspace Member, Contributor, or Admin merely to call
the API. Workspace roles expose unrelated items and management capabilities.

## Applications and ETL processes

An unattended process uses a dedicated Microsoft Entra application/service
principal, not a person's identity. Grant the service principal **Run Queries
and Mutations** on the API item using the same Fabric permission screen.

Use a separate identity per production application so access can be revoked,
audited, and rotated independently. See
[C# and Node.js application clients](../clients/applications.md).

## Data-source connectivity

The API owner can check the GraphQL item's data-source connection mode.

| Connection mode | Caller needs API permission | Caller needs data-source permission |
| --- | --- | --- |
| Saved credentials | Yes | No; the saved connection identity reads the source |
| Single sign-on (SSO) | Yes | Yes; the caller's identity is passed to the source |

For SSO, grant only the minimum read access required by the exposed schema. For
saved credentials, consumers normally need access only to the GraphQL item.
Microsoft's current permission matrix is in
[Connect applications to Fabric API for GraphQL](https://learn.microsoft.com/en-us/fabric/data-engineering/connect-apps-api-graphql#authentication-and-permissions-summary).

## Read-only operation

The Fabric permission label includes the words “and Mutations”; Fabric does not
currently provide a separately named query-only execution permission. Read-only
operation is enforced by the API design and data source:

- expose query operations only in the GraphQL schema;
- do not expose create, update, or delete mutations;
- grant the backend identity only the required `SELECT` permissions;
- periodically review the schema after data sources change.

SQL analytics endpoint sources are query-only in Fabric, but other supported
sources can expose mutations. Do not rely on the permission label alone.

