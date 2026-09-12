"""Show a test GUI and write separate stdout/stderr messages every second."""

import argparse
from datetime import datetime
import sys
import tkinter as tk
from tkinter import font, ttk


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--interval-seconds", type=int, default=1, metavar="SECONDS",
        help="seconds between messages (1-3600; default: 1)",
    )
    args = parser.parse_args()
    if not 1 <= args.interval_seconds <= 3600:
        parser.error("--interval-seconds must be between 1 and 3600")

    window = tk.Tk()
    window.title("Supervisor test child - EXPECTED GUI")
    width, height = 520, 180
    x = max(0, (window.winfo_screenwidth() - width) // 2)
    y = max(0, (window.winfo_screenheight() - height) // 2)
    window.geometry(f"{width}x{height}+{x}+{y}")
    window.attributes("-topmost", True)
    window.protocol("WM_DELETE_WINDOW", window.destroy)

    label_font = font.nametofont("TkFixedFont").copy()
    label_font.configure(size=12)
    label = ttk.Label(window, anchor="center", justify="center", font=label_font)
    label.pack(fill="both", expand=True, padx=12, pady=12)

    iteration = 0

    def tick():
        nonlocal iteration
        iteration += 1
        timestamp = datetime.now().astimezone().isoformat()

        # Flush each message so Supervisor can show it immediately.
        print(f"[{timestamp}] stdout probe iteration {iteration}", flush=True)
        print(
            f"[{timestamp}] stderr probe iteration {iteration}",
            file=sys.stderr, flush=True,
        )
        label.configure(text=f"Expected test GUI\nIteration: {iteration}\n{timestamp}")

        # Schedule the next update without blocking the GUI.
        window.after(args.interval_seconds * 1000, tick)

    window.after(0, tick)
    window.mainloop()


if __name__ == "__main__":
    main()
