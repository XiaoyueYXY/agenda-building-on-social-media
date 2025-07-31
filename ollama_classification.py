import ollama
import numpy as np
import json

def classify_tweet_with_ollama(text, model, message):
    """
    Sends a tweet to the Ollama model for classification and extracts the result and CoT from JSON.
    """
    full_prompt = message.format(tweet_text=text)
    try:
        response = ollama.chat(
            model=model,
            messages=[{'role': 'user', 'content': full_prompt}],
            options={'temperature': 0.0}
        )
        content = response['message']['content'].strip()

        classification = np.nan
        cot = ""

        try:
            parsed_json = json.loads(content)
            # Extract values from the parsed JSON
            if 'classification' in parsed_json:
                classification = int(parsed_json['classification'])
            if 'cot' in parsed_json:
                cot = parsed_json['cot']
            else:
                print(f"Warning: No JSON found in LLM output for tweet: {text[:50]}...")
                print(f"LLM output (first 100 chars): {content[:100]}...")
                cot = content # Store full content if JSON not found

        except (json.JSONDecodeError, ValueError) as e:
            print(f"Warning: JSON parsing/conversion error for tweet: {text[:50]}... Error: {e}")
            print(f"LLM raw output: {content[:100]}...")
            cot = content # Store raw content if parsing failed

        return classification, cot

    except Exception as e:
        print(f"Error classifying tweet: {text[:50]}... Error: {e}")
        return np.nan, f"Error during classification: {e}"