from get_apps import get_apps


def build_apps(app_list: list[str]) -> list[str]:
    print("Building apps...")

    apps_to_deploy = []
    for app in app_list:
        print(f"Building {app}...")
        apps_to_deploy.append(app)

    return apps_to_deploy


if __name__ == "__main__":
    apps = get_apps()
    build_apps(apps)
