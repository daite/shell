import argparse
import json
import os
from googleapiclient.discovery import build
import yt_dlp

# Replace with your YouTube Data API v3 key
#API_KEY = 'AIzaSyAbDw0w3QS_OhCZ6vW72QxdQjYN_oViM70'

# File to store the API key
CONFIG_FILE = 'config.json'

class YouTubeDownloader:
    def __init__(self):
        self.api_key = self.load_api_key()
        self.youtube = None
        if self.api_key:
            self.youtube = build('youtube', 'v3', developerKey=self.api_key)

        # Define channel IDs for BBC News and Bloomberg Technology
        self.channels = {
            "BBC News": "UC16niRr50-MSBwiO3YDb3RA",  # BBC News
            "Bloomberg Technology": "UCrM7B7SL_g1edFOnmj-SDKg"  # Bloomberg Technology
        }

    def load_api_key(self):
        # Load the API key from the config file if it exists
        if os.path.exists(CONFIG_FILE):
            with open(CONFIG_FILE, 'r') as f:
                config = json.load(f)
                return config.get('api_key')
        return None

    def save_api_key(self, api_key):
        # Save the API key to the config file
        with open(CONFIG_FILE, 'w') as f:
            json.dump({'api_key': api_key}, f)
        print("API key saved successfully.")

    def get_videos(self, channel_id, num_videos):
        # Request to get the latest videos
        request = self.youtube.search().list(
            part='snippet',
            channelId=channel_id,
            maxResults=num_videos,  # Number of videos to retrieve
            order='date',
            type='video'
        )
        response = request.execute()

        videos = []
        for item in response['items']:
            title = item['snippet']['title']
            video_id = item['id']['videoId']
            video_url = f'https://www.youtube.com/watch?v={video_id}'
            videos.append((title, video_url))

        return videos

    def download_video_with_subtitles(self, video_url):
        ydl_opts = {
            'format': 'bestvideo[height<=1080]+bestaudio/best[height<=1080]',  # Select 1080p video if available
            'writesubtitles': True,  # Download subtitles
            'subtitleslangs': ['en'],  # Specify the subtitle language(s) you want (e.g., 'en' for English)
            'subtitlesformat': 'srt',  # Subtitle format (e.g., 'srt' or 'vtt')

        }

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([video_url])

    def select_channel_and_download(self, num_videos):
        try:
            print("Select a channel:")
            for idx, channel in enumerate(self.channels.keys(), start=1):
                print(f"{idx}. {channel}")

            channel_choice = int(input("\nEnter the number of the channel: ")) - 1
            selected_channel_id = list(self.channels.values())[channel_choice]

            videos = self.get_videos(selected_channel_id, num_videos)

            print("\nAvailable videos:\n")
            for idx, (title, _) in enumerate(videos):
                print(f"{idx + 1}. {title}")

            video_choice = int(input("\nSelect the number of the video to download: ")) - 1

            if 0 <= video_choice < len(videos):
                selected_video_url = videos[video_choice][1]
                print(f"\nDownloading: {videos[video_choice][0]} (1080p with subtitles)")
                self.download_video_with_subtitles(selected_video_url)
            else:
                print("Invalid selection!")
        except KeyboardInterrupt:
            print("\nProcess interrupted. Exiting gracefully...")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="YouTube Video Downloader with Subtitles")
    parser.add_argument('--add', metavar='key', type=str, help="Add a new YouTube Data API key")
    parser.add_argument('--num', metavar='N', type=int, default=10, help="Number of videos to retrieve (default: 10)")

    args = parser.parse_args()

    downloader = YouTubeDownloader()

    if args.add:
        # Save the provided API key
        downloader.save_api_key(args.add)
    elif downloader.api_key:
        # Proceed to video selection and download if the API key exists
        downloader.select_channel_and_download(args.num)
    else:
        print("No API key found! Please add one using the --add option.")
