import subprocess


def run_command(cmd):
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    o, _ = proc.communicate()
    return o.decode("ascii")


def filter_text(text, filter):
    return text.lower().find(filter.lower()) == 1


def parse_config(config):
    res = {}
    for line in config.split(";"):
        if "=" in line:
            line = line.replace("{", "").replace("}", "").strip()
            x, y = line.split("=", maxsplit=1)
            x, y = x.strip(), y.strip()
            res[x] = y
    return res


if __name__ == "__main__":
    prev_configs = None

    while True:
        stop = input("Enter empty string to continue, else return")

        if stop:
            break

        domains = [
            o.strip()
            for o in run_command(["defaults", "domains"]).split(", ")
            if "agent" not in o.lower()
        ]

        curr_configs = {}

        for domain in domains:
            config = run_command(["defaults", "read", domain])

            if not config:
                continue

            curr_configs[domain] = parse_config(config)

        if prev_configs:
            change_found = False

            for domain in domains:
                if domain not in prev_configs or domain not in curr_configs:
                    continue

                for key, prev_value in prev_configs[domain].items():
                    if key not in curr_configs[domain]:
                        change_found = True
                        print(f"{domain}: Key ({key}) deleted")
                    else:
                        curr_value = curr_configs[domain][key]
                        if prev_value != curr_value:
                            change_found = True
                            print(
                                f"{domain}: Key ({key}) changed from value ({prev_value}) to ({curr_value})"
                            )

                for key, curr_value in curr_configs[domain].items():
                    if key not in prev_configs[domain]:
                        change_found = True
                        print(f"{domain}: Key ({key}) added")

            if not change_found:
                print("No config changes found")

        prev_configs = curr_configs
