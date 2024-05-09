from get_apps import get_apps
import argparse

VALID_ENVS: list[str] = ["ci", "qa-mco"]


def deploy_apps():
    apps = get_apps()

    deployed_apps = []
    for app in apps:
        print(f"Deploying {app}...")
        try:
            deployed_apps.append(app)
        except Exception as e:
            print(f"Failed to deploy {app}: {e}")
            # TODO: Do we want to continue if any fail?

    for deployed_app in deployed_apps:
        print(f"Deployed {deployed_app}")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-e", "--environment", help="Environment to deploy to", required=True
    )

    args = parser.parse_args()

    if args.environment not in VALID_ENVS:
        print(
            f"Invalid environment: {args.environment}"
            f"\nValid environments are: {VALID_ENVS}"
        )
        exit(1)

    print(f"Deploying apps to {args.environment} environment")


if __name__ == "__main__":
    parse_args()
    deploy_apps()
