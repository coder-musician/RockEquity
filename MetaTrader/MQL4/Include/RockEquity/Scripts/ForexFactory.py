import re
import json
import os
from datetime import datetime, timedelta
import time

# -----------------------
# Settings
# -----------------------
input_html_file = r"./Resources/ForexFactory.html"
json_file       = r"./Resources/Calendar.json"
output_txt_file = r"../Files/FFcal.txt"

MinutesInAdvance = 120  # Time window in minutes
NewsLifeTime     = 5  # Minutes after event to still show

# -----------------------
# Helper functions
# -----------------------
def extract_json_from_html(html_file, json_file):
    """Extract JSON from ForexFactory HTML and save it."""
    with open(html_file, "r", encoding="utf-8") as f:
        line = f.read().strip()

    match = re.search(r"days\s*:\s*(\[\{.*\}\])", line)
    if match:
        days_json_str = match.group(1)
        days_json_str = days_json_str.replace("\\/", "/")  # fix slashes
        try:
            days_data = json.loads(days_json_str)
            with open(json_file, "w", encoding="utf-8") as f:
                json.dump(days_data, f, indent=4)
            print(f"✅ JSON extracted and saved to '{json_file}'")
            return days_data
        except json.JSONDecodeError as e:
            print(f"❌ Error decoding JSON: {e}")
            return None
    else:
        print("❌ 'days' variable not found in the HTML.")
        return None

def get_event_name(event):
    """Return the event name from common keys."""
    for key in ["eventName", "name", "event", "title"]:
        if key in event and event[key]:
            return event[key]
    return ""  # fallback if none found

def time_left(event_time):
    """Calculate time left until event occurs (largest relevant unit)."""
    now = datetime.now()
    delta = event_time - now
    total_seconds = int(delta.total_seconds())

    if total_seconds <= 0:
        return "0s"

    hours, remainder = divmod(total_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)

    if hours > 0:
        return f"{hours}h"
    elif minutes > 0:
        return f"{minutes}m"
    else:
        return f"{seconds}s"

def get_upcoming_events(events_data, time_window_minutes=MinutesInAdvance):
    """Filter events within the time window or recent past."""
    now = datetime.now()
    all_events = []

    for day in events_data:
        all_events.extend(day.get("events", []))

    upcoming_events = []
    for event in all_events:
        try:
            event_time = datetime.fromtimestamp(event["dateline"])
        except KeyError:
            continue

        time_diff = (event_time - now).total_seconds() / 60  # minutes

        if -NewsLifeTime <= time_diff <= time_window_minutes:
            event["time_left"] = time_left(event_time)
            upcoming_events.append(event)

    return upcoming_events

def write_to_text_file(messages, filepath):
    """Write the list of messages to a text file."""
    with open(filepath, 'w', encoding='utf-8') as f:
        for msg in messages:
            f.write(msg + "\n")

def delete_text_file(filepath):
    if os.path.exists(filepath):
        os.remove(filepath)

# -----------------------
# Main
# -----------------------
if __name__ == "__main__":

    while(True):
        # Step 1: Extract JSON from HTML
        data = extract_json_from_html(input_html_file, json_file)
        if not data:
            delete_text_file(output_txt_file)
            exit()

        # Step 2: Filter upcoming events
        events = get_upcoming_events(data)

        if events:
            messages = []  # no header

            for event in events:
                name = get_event_name(event)

                # Replace empty/blank impactName with a dot
                impact = event.get('impactName')
                if not impact or str(impact).strip() == "":
                    impact = "."

                message = f"{event['timeLabel']},{event['time_left']},{event['currency']},{name},{impact},{event.get('actual','')},{event.get('forecast','')},{event.get('previous','')}"
                print(message)
                messages.append(message)

            write_to_text_file(messages, output_txt_file)
            print(f"Messages written to '{output_txt_file}'")
        else:
            delete_text_file(output_txt_file)
            print(f"No upcoming events within the next {MinutesInAdvance} minutes or within {NewsLifeTime} minutes after the event. '{output_txt_file}' deleted if it existed.")

        time.sleep(1)
