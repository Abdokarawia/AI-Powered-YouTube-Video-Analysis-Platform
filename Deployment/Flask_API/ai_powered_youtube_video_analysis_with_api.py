# -*- coding: utf-8 -*-
"""AI-Powered YouTube Video Analysis.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1AmTNBbL_lmWCcY_jMF4tRe4Y4YeRoxdU

# **🔧 Setup for Google Generative AI Integration**

This script sets up the environment to work with Google Generative AI in Google Colab. It includes the installation of necessary packages and configuration of the API key.

## 📜 Steps Included:

1. **Install the Google Generative AI package**:
   - We use the `pip` command to install or update the `google-generativeai` package.
   
2. **Import necessary modules**:
   - The `google.generativeai` module is essential for interacting with the AI services.
   - The `userdata` module from Colab is used to securely retrieve the API key.

3. **Retrieve and configure API key**:
   - We securely access the Google API key stored in the user's Colab environment and configure the `google.generativeai` module with this key.
"""

# Step 1: Install the Google Generative AI package
!pip install -q -U google-generativeai

# Step 2: Import necessary modules
import google.generativeai as genai         # Google Generative AI module
from google.colab import userdata           # Colab module to handle user data securely

# Step 3: Retrieve and configure API key
GOOGLE_API_KEY = userdata.get('GOOGLE_API_KEY') # Securely retrieve API key from Colab's environment
genai.configure(api_key=GOOGLE_API_KEY)     # Configure the Google Generative AI module with the API key

"""## **📋 Safety Settings Configuration**

This configuration list specifies different categories of harmful content and their corresponding thresholds.

## 🛠️ Configuration Details:

- **Category**:
  - Describes the type of harmful content that the system should monitor.
  
- **Threshold**:
  - Determines the blocking level for the specified content category.
  - `"BLOCK_NONE"` implies that no content will be blocked within these categories.

"""

# Define the safety settings
safety_settings = [
    {
        "category": "HARM_CATEGORY_DANGEROUS",         # ⚠️ Dangerous content
        "threshold": "BLOCK_NONE",                     # Threshold: No blocking
    },
    {
        "category": "HARM_CATEGORY_HARASSMENT",        # 🗣️ Harassment
        "threshold": "BLOCK_NONE",                     # Threshold: No blocking
    },
    {
        "category": "HARM_CATEGORY_HATE_SPEECH",       # 🚫 Hate speech
        "threshold": "BLOCK_NONE",                     # Threshold: No blocking
    },
    {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", # 🔞 Sexually explicit content
        "threshold": "BLOCK_NONE",                     # Threshold: No blocking
    },
    {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT", # 💥 Dangerous content
        "threshold": "BLOCK_NONE",                     # Threshold: No blocking
    },
]

"""# 🎥 **Video to Audio Converter**

This script downloads a video from a YouTube link and converts it into an audio file (MP3 format).
We use the `pytube` library for downloading the video and `moviepy` for extracting the audio.

## 📦 Required Libraries

- `yt-dlp`: For downloading videos from YouTube.
- `moviepy`: For handling video and audio processing.

Install the libraries if you haven't already:

"""

!pip install pytubefix

# Import the necessary modules from the pytubefix library
from pytubefix import YouTube
from pytubefix.cli import on_progress

# Define the URL of the YouTube video to download
url = "https://youtu.be/_RHIECWv728?si=13cCq11UgE6DPpS4"

# Create a YouTube object for the specified URL
# The on_progress_callback parameter is used to display download progress
yt = YouTube(url, on_progress_callback=on_progress)

# Print the title of the YouTube video to confirm the correct video is being downloaded
print(f"Video Title: {yt.title}")

# Get the audio-only stream from the video
audio_stream = yt.streams.get_audio_only()

# 💾 Download the audio stream as an MP3 file
audio_stream.download(mp3=True, filename="AudioFile")

from IPython.display import Audio

# Path to the audio file
file_path = '/content/AudioFile.mp3'

# Display the audio player in the notebook
Audio(file_path)

"""# 🎵 **Audio Transcription with GenAI**

This notebook demonstrates how to transcribe an audio file into **English** and **Arabic** text using the GenAI API. You can upload an MP3 file and generate text content in both languages.

## 📂 **Uploading the Audio File**

Use the following code to upload your MP3 file. Replace `'sample.mp3'` with the path to your audio file.

"""

AudioFile = genai.upload_file(path='/content/AudioFile.mp3')

"""##📝 **Generating Transcription**

To generate the transcription, you'll need to set up the prompt and use the GenerativeModel from GenAI. Below is the code for generating the English and Arabic text from the audio file
"""

# Define your prompt for the transcription
prompt = "I need Explanation of the audio file for the user to understand for this audio"

# Initialize the GenerativeModel with the desired model
model = genai.GenerativeModel('gemini-1.5-flash-001')

# Generate the content using the model and your file
response = model.generate_content([prompt, AudioFile], safety_settings=safety_settings)

# Print the transcribed text
print(response.text)

"""# 🚀 **Meta-Llama Text Generation Model**
Welcome to the implementation of **Meta-Llama 3B** text generation model, utilizing cutting-edge optimizations such as **4-bit quantization** and **low memory usage**. This guide will walk you through the installation, initialization, and usage of the model using the **Hugging Face `transformers` library**.

Let's get started! 🎯

"""

!huggingface-cli login --token "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"

# 📥 **Step 1: Install Required Libraries**
# Before we can start using the Meta-Llama model, we need to install the necessary libraries.

!pip install --upgrade transformers  # Install/Upgrade transformers for model loading
!pip install sentence-transformers   # Install sentence-transformers for embeddings
!pip install bitsandbytes accelerate # Install bitsandbytes and accelerate for fast inference
!pip install -U langchain-community  # Upgrade the Langchain community library

# 📝 Uncomment below if llama-cpp is needed:
# !pip install llama-cpp-python

"""# 🧠 **Step 2: Import Libraries**

Let's import the essential Python libraries for **transformers** and **PyTorch** to handle model loading, text generation, and computations.

- `transformers.pipeline`: for easy text generation setup
- `torch`: for hardware acceleration

"""

from transformers import pipeline
import torch
import transformers

"""# 🦙 **Step 3: Initialize Meta-Llama-3B Model**

In this step, we'll initialize the **Meta-Llama-3-8B-Instruct** model from Hugging Face. We enable several optimizations to make it run smoothly on machines with limited resources.

### ⚙️ **Optimizations:**
1. **4-bit Quantization**: Reduces model size without losing much accuracy.
2. **16-bit Floating Point Precision**: Speeds up computation.
3. **Low CPU Memory Usage**: Ideal for environments with limited memory.

"""

# 🎯 Define the model ID for Meta-Llama
model_id = "meta-llama/Meta-Llama-3.1-8B-Instruct"

# 🚀 Step 1: Initialize the pipeline for text generation with efficient settings
pipe = transformers.pipeline(
    "text-generation",
    model=model_id,
    model_kwargs={
        "torch_dtype": torch.float16,  # Use 16-bit precision for faster computation
        "quantization_config": {"load_in_4bit": True},  # Enable 4-bit quantization for reduced memory usage
        "low_cpu_mem_usage": True,  # Optimize for low CPU memory usage
    },
)

"""# 🎥 **In-Depth Video Analysis using Meta-Llama Model in One Step**
In this example, we utilize the **Meta-Llama** text generation model to simulate a detailed analysis of a video based on user messages. This code will:
1. Prepare the input messages.
2. Set up token terminators for proper tokenization.
3. Generate the text response based on the model's configuration.
4. Display the assistant's generated response.

All of this is done in a single step! 🚀

"""

# 📨 **Step 2: Prepare the messages for analysis**
messages = [
    {"role": "system", "content": "Hi there! Could you help me by analyzing this video? I've sent the link, and I'd love for you to explain every detail thoroughly as if you were a human. I'm looking for an in-depth breakdown that covers every aspect in at least 100 lines or more. Can you dive into every little detail for me, even if it gets a bit boring?"},  # 🧑‍💻 System's instruction
    {"role": "user", "content": "Sample video content analysis request"}  # 🧑 User's message (video link or content)
]

# 🚦 **Step 3: Define token terminators for the end of sequence**
terminators = [
    pipe.tokenizer.eos_token_id,  # 🛑 End of sequence token for proper termination
    pipe.tokenizer.convert_tokens_to_ids("<|eot_id|>")  # 🔄 Convert empty string to token ID
]

# 🎯 **Step 4: Generate the text response**
outputs = pipe(
    messages,  # 📩 Input the prepared messages
    max_new_tokens=512,  # ✍️ Limit the generated text to 512 tokens
    eos_token_id=terminators,  # 🛑 Define when the generation should stop
    do_sample=True,  # 🎲 Enable random sampling for more creative responses
    temperature=0.6,  # 🔥 Control randomness (0.6 is a balanced value)
    top_p=0.9  # 🏔 Apply nucleus sampling to choose from top 90% probable tokens
)

# 📄 **Step 5: Extract and print the generated response**
assistant_response = outputs[0]["generated_text"][-1]["content"]  # 📝 Extract the assistant's response
print(assistant_response)  # 📢 Output the result

!pip install pyngrok

"""# 🦙 **Flask API for YouTube Video Transcription & Analysis using genAi Gemini**

🚀 This API automates the process of downloading a YouTube video's audio, transcribing it using **genAi Gemini**, and performing an in-depth analysis using the **Meta-Llama** model. The API is publicly accessible via **ngrok**.



🔑 **Key Features:**
- **Flask** web server to handle POST requests with YouTube links.
- **YouTube video download** using `pytubefix` for audio extraction.
- **Audio transcription** via genAi Gemini for generating accurate transcripts.
- **Meta-Llama analysis** to provide detailed breakdowns of video content.
- **Ngrok integration** for globally accessible API.



📝 **Steps Overview:**

 1. 📩 Receive a YouTube video URL via a POST request.
 2. 📥 Download the video’s audio stream and save it as an MP3.
 3. 📝 Upload the audio file and transcribe it using genAi Gemini.
 4. 🧠 Generate content analysis using Meta-Llama based on the transcription.
 5. 💬 Return the generated analysis back to the user.
"""

from operator import imod
from flask import Flask, request, render_template, jsonify
from pyngrok import ngrok
from pytubefix import YouTube
from pytubefix.cli import on_progress

app = Flask(__name__)

ngrok.set_auth_token("2RRhuvjyaVQDFx9lqulj0jZSlnS_fJvUWcqPHsFsdX1ssj8a")
public_url =  ngrok.connect(5000).public_url

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()

    if 'Url' not in data:
        return jsonify({'error': 'No Url found in request'}), 400

    # Define the URL of the YouTube video to download
    Url = data['Url']

    print(Url)
    # Create a YouTube object for the specified URL
    yt = YouTube(Url, on_progress_callback=on_progress)

    # Print the title of the YouTube video to confirm the correct video is being downloaded
    print(f"Video Title: {yt.title}")

    # Get the audio-only stream from the video
    audio_stream = yt.streams.get_audio_only()

    # 💾 Download the audio stream as an MP3 file
    audio_stream.download(mp3=True, filename="AudioFile")

    AudioFile = genai.upload_file(path='/content/AudioFile.mp3')

    response = model.generate_content([prompt, AudioFile], safety_settings=safety_settings)

    messages = [
    {"role": "system", "content": "Hi there! Could you help me by analyzing this video? I've sent the link, and I'd love for you to explain every detail thoroughly as if you were a human. I'm looking for an in-depth breakdown that covers every aspect in at least 100 lines or more. Can you dive into every little detail for me, even if it gets a bit boring?"},
    {"role": "user", "content": response.text}]

    outputs = pipe(
              messages,
              max_new_tokens=5025,
              eos_token_id=terminators,
              do_sample=True,
              temperature=0.6,
              top_p=0.9,)

    assistant_response = outputs[0]["generated_text"][-1]["content"]
    print(assistant_response)

    return jsonify(response = assistant_response)

print(f"To acces the Gloable link please click {public_url}")

if __name__ == '__main__':
    app.run(port=5000)