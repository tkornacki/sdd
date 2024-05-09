def build_apps(app_list:list[str])->int:
    print("Building apps...")
    for app in app_list:
        print(f"Building {app}...")
    # Write all the apps to a file
    with open("apps.txt", "w") as f:
        for app in app_list:
            f.write(app + "\n")
    return 1