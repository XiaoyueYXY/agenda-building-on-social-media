# Agenda Buidling on Social Media
This repository contains codes and data for the paper *Shaping the social media news agenda: Explaining organizations’ agenda building success using topic-level newsworthiness*
## Scripts
**data_retrieval**: codes to retrieve tweets with the package *twarc*

**preprocessing**: steps to prepare the data for topic modeling

**topic_model_try**: fine tune the BERTopic model, compare the performance of BERTopic to LDA

**topic_modeling**: conduct topic modeling with the fine-tuned model, visualize the topic model

**ICR**: intercoder reliability for the manually coded topic-level newsfactor

**newsfactor_classification**: full process of prompting and classifying newsfactors using ollama

**ollama_classification**: a function to prompt ollama and document the results

**data_analysis**: prepare the dataset for multilevel modeling, descriptive analyses

**multilevelmodel**: R codes for multilevel modeling
## Data
The tweet id for corporate tweets and media tweets are stored separately in this folder
