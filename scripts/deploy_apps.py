def deploy_apps(apps:list[str]):
    for app in apps:
        print(f"Deploying {app}...")
        # deploy app
        print(f"{app} deployed.")
    print("All apps deployed.")