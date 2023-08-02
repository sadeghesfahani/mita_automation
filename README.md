for running this script properly you need to put `GITHUB_TOKEN` and `GITHUB_USERNAME` in your environment variables

```bash
cd ./etc
sudo nano environment
```

then add these lines to the end of the file

```bash
GITHUB_TOKEN=your_github_token
GITHUB_USERNAME=your_github_username
```

then press `ctrl + x` and then `y` and then `enter`

then you need to give the script permission to run

```bash
sudo chmod +x ./path/to/script.sh
```

then you can run the script

```bash
sudo ./path/to/script.sh
```

