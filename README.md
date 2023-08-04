# Create disks and mount them

## prerequisites

1. 3GB disk for swap
2. 20GB disk for /var

## how to create swap disk

<details>
  <summary>1. Create a disk with 3GB size</summary>
    this part is mostly done by your cloud provider
</details>
<details>
  <summary>2. Create a partition with 3GB size</summary>
    If the disk is not yet partitioned, you'll need to create a partition on it. Use fdisk or another partitioning tool to create the partition.

```bash
sudo fdisk /dev/sdx
```

Follow the interactive prompts to create a partition, and set its type to 'Linux swap' (usually type code 82).
</details>


<details>
  <summary>3. Create a swap file system on the partition</summary>
    After creating the partition, you'll need to create a swap file system on it.

```bash
sudo mkswap /dev/sdx1
```

</details>


<details>
  <summary>4. Add the partition to fstab</summary>
    After creating the swap file system, you'll need to add an entry to /etc/fstab so that the system will use the partition for swap each time it boots.

```bash
sudo nano /etc/fstab
```

Add the following line to the end of the file:

```bash
/dev/sdx1 swap swap defaults 0 0
```

</details>


<details>
  <summary>5. Enable swap</summary>
    After adding the entry to /etc/fstab, you'll need to enable the swap partition.

```bash
sudo swapon -a
```

</details>


<details>
  <summary>6. Check if swap is enabled</summary>
    After enabling the swap partition, you can verify that it's enabled by checking the output of the command swapon -s.

```bash
sudo swapon -s
```

</details>

## how to create a disk for /var

<details>
  <summary>1. Create a disk with 20GB size</summary>
    this part is mostly done by your cloud provider
</details>

<details>
  <summary>2. Create a partition with 20GB size</summary>
    If the disk is not yet partitioned, you'll need to create a partition on it. Use fdisk or another partitioning tool to create the partition.

```bash
sudo fdisk /dev/sdx
```

Follow the interactive prompts to create a partition, and set its type to 'LVM' (usually type code 30, we need `t` for
that).
</details>

<details>
<summary>3. Create system file</summary>

We need to give a system file to the partition

```bash
sudo mkfs.ext4 /dev/sdx1
```

</details>

<details>
<summary>4. Allocate new partition to /var </summary>

```bash
sudo mount /dev/sdx1 /var
```

</details>

<details>
<summary>5. Add the partition to fstab</summary>
    After creating the swap file system, you'll need to add an entry to /etc/fstab so that the system will use the partition for swap each time it boots.

```bash
sudo nano /etc/fstab
```

Add the following line to the end of the file:

```bash
/dev/sdx1 /var ext4 defaults 0 0
```

and finally run this command

```bash
sudo mount -a
sudo reboot
```

</details>

# how to run the script

for running this script properly, you need to put `GITHUB_TOKEN` and `GITHUB_USERNAME` in your environment variables

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

