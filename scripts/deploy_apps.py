from get_apps import get_apps


def deploy_apps(apps: list[str]):
    for app in apps:
        print(f"Deploying {app}...")
        # deploy app
        print(f"{app} deployed.")
    print("All apps deployed.")


if __name__ == "__main__":
    apps = get_apps()
    deploy_apps(apps)
