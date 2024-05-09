from get_apps import get_apps
import sys
import argparse


def deploy_apps(apps: list[str]):
    for app in apps:
        print(f"Deploying {app}...")
        # deploy app
        print(f"{app} deployed.")
    print("All apps deployed.")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-e", "--environment", help="Environment to deploy to", required=True)
    
    args = parser.parse_args()

    print(f'Deploying apps to {args.environment} environment')
          

if __name__ == "__main__":
    # Get the cli args
    args = parse_args()
    apps = get_apps()
    deploy_apps(apps)
