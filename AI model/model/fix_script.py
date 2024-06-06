import json

def fix_notebook(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        notebook = json.load(f)

    for cell in notebook.get('cells', []):
        if cell.get('cell_type') == 'code':
            if 'execution_count' not in cell:
                cell['execution_count'] = None

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(notebook, f, indent=2)

# Path to the notebook file
file_path = 'main2.ipynb'
fix_notebook(file_path)