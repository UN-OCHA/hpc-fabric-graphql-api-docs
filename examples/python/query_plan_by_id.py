"""Query one plan by ID using the signed-in user's Fabric access."""

from __future__ import annotations

import argparse
import json

from fabric_graphql_client import FabricGraphQLClient, GraphQLRequestError


QUERY = """
query PlanById($planId: Int!) {
  plans(first: 1, filter: { Id: { eq: $planId } }) {
    items {
      Id
      Name
      ShortName
      PlanCode
      PlanType
      PlanCosting
      PlanClusterType
      PlanLanguage
      StartDate
      EndDate
      IsReleased
      IsRestricted
      IsPartOfGHO
      IsForHPCProjects

      period(first: 10, orderBy: { CalendarYear: DESC }) {
        items {
          Id
          CalendarYear
          PeriodType
        }
      }

      location(first: 10, filter: { AdminLevel: { eq: 0 } }) {
        items {
          Id
          Name
          ISO3
          Pcode
        }
      }
    }
  }
}
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Return one plan by its ID.")
    parser.add_argument(
        "plan_id",
        nargs="?",
        type=int,
        default=1202,
        help="Plan ID to query; default: 1202.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        with FabricGraphQLClient() as client:
            data = client.execute(
                QUERY,
                {"planId": args.plan_id},
                operation_name="PlanById",
            )
    except (GraphQLRequestError, ValueError) as error:
        print(f"Query failed: {error}")
        return 1

    print(json.dumps(data, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
