import argparse
import json
import os
import re
from googleapiclient.discovery import build
import yt_dlp
from googleapiclient.errors import HttpError

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
            
            # Fetch video duration using video_id
            duration = self.get_video_duration(video_id)
            
            videos.append((title, video_url, duration))

        return videos

    def get_video_duration(self, video_id):
        try:
            request = self.youtube.videos().list(
                part='contentDetails',
                id=video_id
            )
            response = request.execute()
            duration = response['items'][0]['contentDetails']['duration']
            return self.parse_duration(duration)
        except HttpError as e:
            print(f"An error occurred: {e}")
            return "Unknown"

    def parse_duration(self, duration):
        # Parse ISO 8601 duration format (e.g., PT1H2M3S) into a human-readable format
        hours = re.search(r'(\d+)H', duration)
        minutes = re.search(r'(\d+)M', duration)
        seconds = re.search(r'(\d+)S', duration)
        
        hours = int(hours.group(1)) if hours else 0
        minutes = int(minutes.group(1)) if minutes else 0
        seconds = int(seconds.group(1)) if seconds else 0
        
        return f'{hours}h {minutes}m {seconds}s' if hours > 0 else f'{minutes}m {seconds}s'

    def download_video_with_subtitles(self, video_url):
        ydl_opts = {
            'format': 'bestvideo[height<=1080]+bestaudio/best[height<=1080]',  # Select 1080p video if available
            'writesubtitles': True,  # Download subtitles
            'subtitleslangs': ['en'],  # Specify the subtitle language(s) you want (e.g., 'en' for English)
            'subtitlesformat': 'srt',  # Subtitle format (e.g., 'srt' or 'vtt')
            'outtmpl': '%(title)s.%(ext)s'  # Save file with video title
        }

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            result = ydl.download([video_url])
            # Get the downloaded file name and calculate file size
            info_dict = ydl.extract_info(video_url, download=False)
            filename = ydl.prepare_filename(info_dict)
            if os.path.exists(filename):
                file_size = os.path.getsize(filename)
                print(f"Downloaded file size: {file_size / (1024 * 1024):.2f} MB")
            else:
                print("File size could not be determined.")

    def select_channel_and_download(self, num_videos):
        try:
            print("Select a channel:")
            for idx, channel in enumerate(self.channels.keys(), start=1):
                print(f"{idx}. {channel}")

            channel_choice = int(input("\nEnter the number of the channel: ")) - 1
            selected_channel_id = list(self.channels.values())[channel_choice]

            videos = self.get_videos(selected_channel_id, num_videos)

            print("\nAvailable videos:\n")
            for idx, (title, _, duration) in enumerate(videos):
                print(f"{idx + 1}. {title} (Duration: {duration})")

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
