Reduce Storage Costs with EFS
Introduction
Amazon Elastic File System (Amazon EFS) provides a simple, serverless elastic file system that lets you share file data without provisioning or managing storage. In this lab, we modify three existing EC2 instances to use a shared EFS storage volume instead of duplicated Elastic Block Store volumes. This reduces costs significantly, as we only need to store data in one location instead of three. By the end of this lab, you will understand how to create EFS volumes and attach them to an EC2 instance.

Solution
Log in to the AWS Management Console using the credentials provided on the lab instructions page. Make sure you're using the us-east-1 region.

Create an EFS File System
Review Your Resources
Navigate to EC2 using the Services menu or the unified search bar.

In the Resources section, select Instances (running).

Click the checkbox next to webserver-01.

The instance details display below.

Select the Storage tab and note the 10 GiB disk attached to the volume.

This is the same configuration used for webserver-02 and webserver-03.

Create an EFS Volume
In a new browser tab, navigate to EFS.

On the right, click Create file system.

Fill in the file system details:

Name: In the text box, enter SharedWeb.
Virtual Private Cloud (VPC): Use the dropdown to select the provided VPC.
Availability and durability: Select One Zone.
Availability Zone: Leave us-east-1a selected.
Click Create to create the file system.

After the file system is successfully created, click View file system in the top right corner.

Select the Network tab and wait for the created network to become available.

Note: You may need to refresh the Network details to see an updated mount target status.

After the mount target state is available, click Manage on the right.

Under Security groups, remove the currently attached default security group and then use the dropdown menu to select the EC2SecurityGroup group (not the default group).

Click Save.

Configure the Security Groups
Navigate back to the EC2 browser tab.

In the sidebar menu, select Security Groups.

Click the checkbox next to the non-default security group to show the security group details.

Select the Inbound rules tab and then click Edit inbound rules on the right.

Click Add rule and configure the rule:

Type: Use the dropdown to select NFS.
Source: Use the text box to select 0.0.0.0/0.
Click Save rules.

In the sidebar menu, select EC2 Dashboard and then select Instances (running).

With webserver-01 selected, click Connect along the top right.

Click Connect.

This should take you to a new terminal showing your EC2 instance in a new browser tab or window.

Mount the EFS File System and Test It
Mount the File System
In the terminal, list your block devices:

lsblk
View the data inside the 10 GiB disk mounted to /data:

ls /data
You should see file.01-file.10 listed.

Create a directory to attach your EFS volume:

sudo mkdir /efs
Navigate back to the EFS tab showing the SharedWeb file system details.

In the top right, click Attach.

In the dialog, select Mount via IP.

Copy the provided NFS command to your clipboard.

Navigate back to the terminal and paste in the command.

Edit the mount point by changing efs to /efs in the command:

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 10.0.0.47:/ /efs
Press Enter to run the command.

Test the File System
View the newly mounted EFS volume:

ls /efs
Nothing will be returned, but that shows that the EFS volume is mounted.

List the block devices again:

lsblk
Your NFS mount is not yet listed.

View the mounts:

mount
Toward the bottom, you should see that your NFS share is mounted on /efs.

View file system mounts:

df -h
Again, you should see that your NFS share is mounted on /efs.

Move all files from /data to the /efs file system:

sudo rsync -rav /data/* /efs
View the files now in the /efs file system:

ls /efs
This time, a list should be returned.

Remove Old Data
Remove Data from webserver-01
Unmount the partition:

sudo umount /data
Open the /etc/fstab file in an editor:

sudo nano /etc/fstab
Remove the line starting with UUID by placing the cursor at the beginning of the line and pressing Ctrl+K.

Build a new mount point:

Navigate back to the EFS tab and ensure the Attach dialog is still open from the previous objective.

Copy the IP address listed in the provided command.

Navigate back to the terminal and paste your copied IP address.

Press Tab twice so your cursor aligns with the / on the first line, and then add /data.

Press Tab and then Space once so your cursor aligns with ext4 on the first line, and then add nfs4.

Navigate back to the EFS tab and copy the options from the command (starting with nfsvers and ending with noresvport).

Navigate back to the terminal and paste your copied options so they align with defaults, discard on the first line.

Press Tab and then add 0 0 to the end of your mount point entry.

Your mount point should now look like this:

<NFS MOUNT IP>:/ 		/data 	nfs4 	 <OPTIONS> 0 0
Press Ctrl+X to exit Nano.

Press Y to save your changes and then press Enter to write to the file.

Unmount the /efs to confirm your edits were successful:

sudo umount /efs
View the file systems:

df -h
You should see that you don't have /data or /efs mounted.

Try and mount everything that is not already mounted:

sudo mount -a
View the file systems again and check if 10.0.0.180:/ is mounted:

df -h
You should see the NFS share is now mounted on /data.

View the contents of /data:

ls /data
You should see file.01-file.10 listed.

Remove the EFS Volume Attached to webserver-01
Navigate back to EC2 tab showing the Connect to instance page.

Use the breadcrumb along the top of the page to select EC2.

In the Resources section of the main pane, click Volumes.

Scroll to the right and expand the Attached Instances column to find the 10 GiB volume attached to webserver-01.

Click the checkbox next to the 10 GiB volume attached to webserver-01.

In the top right, use the Actions dropdown to select Detach volume.

Click Detach to confirm your choice.

When the volume is detached, it will show as Available. You may need to refresh the page.

After the volume is detached, click the checkbox next to the same volume again.

In the top right, use the Actions dropdown to select Delete volume.

Click Delete to confirm your choice.

Remove Data from webserver-02 and webserver-03
In the EC2 sidebar menu, select Instances.

Click the checkbox next to webserver-02.

Along the top of the page, click Connect.

Click Connect.

This should launch a terminal in a new browser window or tab.

Navigate to the webserver-01 terminal and view the contents of /etc/fstab:

cat /etc/fstab
Copy the mount point on the second line (starting with an IP) to your clipboard:

<NFS MOUNT IP>:/ 		/data 	nfs4 	 <OPTIONS> 0 0
Navigate back to the terminal you launched for webserver-02.

Unmount the /data partition:

sudo umount /data
Open the /etc/fstab file in an editor:

sudo nano /etc/fstab
Edit /etc/fstab:

Remove the line starting with UUID by placing the cursor at the beginning of the line and pressing Ctrl+K.
Paste in the line from your clipboard and reformat it so it aligns with the line above (it should look the same as in webserver-01).
Press Ctrl+X to exit Nano.
Press Y to save your changes and then press Enter to write to the file.
Mount the partition:

sudo mount -a
View the file systems:

df -h
View the contents of /data:

ls /data
You should see file.01-file.10, indicating you are using the shared EFS volume.

Repeat this entire process for webserver-03.

Remove the EFS Volumes Attached to EC2
Navigate back to the EC2 tab showing the Connect to instance page.
Use the breadcrumb along the top of the page to select EC2.
In the Resources section, select Volumes.
Check the checkboxes for both of the 10 GiB volumes.
Use the Actions dropdown to select Detach volume.
Type detach into the text box to confirm your choice, and then click Detach.
After both volumes are detached, select them again using the checkboxes.
Use the Actions dropdown to select Delete volume.
Type delete into the text box to confirm your choice, and then click Delete.