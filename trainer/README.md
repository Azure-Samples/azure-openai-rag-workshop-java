# Trainer material

This directory contains the material for the trainer, when this workshop is given in a classroom setting.

It also contains a proxy that you can use to share your Azure OpenAI instance with your attendees.

## Content

- The introduction slides are in the `docs/slides` folder, and available at https://azure-samples.github.io/azure-openai-rag-workshop-java/
- The workshop is in the `docs/workshop` folder, and available at https://aka.ms/ws/openai-rag

## Preparation

Since Azure OpenAI is not enabled by default on all subscriptions, it's difficult for attendees to follow the workshop with their own instance.

To solve that issue, this folder containers an OpenAI proxy that you can share with your attendees.

To deploy it, run:

```bash
azd auth login # if needed
azd env new openai-trainer
azd env set AZURE_OPENAI_LOCATION <location> # optional, default is swedencentral
azd env set AZURE_OPENAI_CAPACITY <tokens_per_minutes> # optional, default is 200
azd up
```

You'll get a container app instance URL of the proxy when the deployment is complete.

You can share it with your attendees so they can use it during the workshop with a link like this:

```
https://aka.ms/ws/openai-rag-quarkus?vars=proxy:<proxy_url>
```


## During the workshop

Share this URL with your attendees, and make them run this command **before** their provision their own infrastructure (if they already did it, they'll just have to provision again):

```bash
azd env set AZURE_OPENAI_URL <proxy_url>
```
