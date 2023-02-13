import requests
import json
import datetime

headers = {'Private-Token': 'glpat-9s3aPqFU1smmHxCzTWKh'}
url = f'https://gitlab.com/api/v4/projects/{42660645}/pipelines'

response = requests.get(url, headers=headers)

if response.status_code == 200:
    try:
        pipelines = response.json()
    except json.JSONDecodeError as e:
        print(f"Failed to parse response as JSON: {e}")
        pipelines = []
else:
    print(f"Failed to retrieve pipelines, status code: {response.status_code}")
    print(f"Response content: {response.content}")
    pipelines = []

if pipelines:
    # Get the latest pipeline
    latest_pipeline = pipelines[0]

    # Get the latest artifacts links
    artifacts_files = latest_pipeline.get('artifacts_files', [])
    artifacts_links = [artifact.get('url', '') for artifact in artifacts_files]

    content = '## Latest Pipeline and Artifacts Information\n\nPipeline ID: {}\n\nArtifa( _)cts Links:\n\n'.format(latest_pipeline['id'])
    content += '\n'.join(['- {}'.format(link) for link in artifacts_links])

    url = f'https://gitlab.com/api/v4/projects/{42660645}/wikis'

    # Define the parameters for creating the wiki page
    data = {
        'title': f'Pipeline and Artifacts Inform( _)ation - {datetime.datetime.now().strftime("%Y-%m-%d")}',
        'content': content,
        'format': 'markdown',
        'message': 'Create wiki page wi( _)th latest pipeline and artifacts information'
    }

    response = requests.post(url, headers=headers, data=data)

    if response.status_code == 201:
        print("Wiki page created successfully!")
    else:
        print(f"Failed to crt wiki page, status code: {response.status_code}")
        print(f"Response content: {response.content}")
else:
    print("No pipelines found, cannot create wiki page.")
