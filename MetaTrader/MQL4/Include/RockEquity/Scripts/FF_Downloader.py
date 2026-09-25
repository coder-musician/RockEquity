from selenium import webdriver
from selenium.webdriver.firefox.options import Options
import time
import os

def download_forexfactory_html(
    output_file="./Resources/ForexFactory.html"
):
    url = "https://www.forexfactory.com/"

    # Setup Firefox options
    options = Options()
    options.headless = True  # Run in background
    options.add_argument("--width=1920")
    options.add_argument("--height=1080")

    # Optional: use a temporary profile to avoid conflicts
    profile_dir = "/tmp/ff_selenium_profile"
    if not os.path.exists(profile_dir):
        os.makedirs(profile_dir)
    options.set_preference("profile", profile_dir)

    # Start Firefox browser
    driver = webdriver.Firefox(options=options)

    try:
        print("Opening ForexFactory...")
        driver.get(url)

        # Wait for JavaScript to load the calendar
        time.sleep(5)

        # Get rendered HTML
        html = driver.page_source

        # Save to file
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(html)

        print(f"✅ Rendered HTML saved to {output_file}")

    except Exception as e:
        print(f"❌ Error: {e}")

    finally:
        driver.quit()

if __name__ == "__main__":
    
    while(True):

        download_forexfactory_html()
        time.sleep(120)
    
