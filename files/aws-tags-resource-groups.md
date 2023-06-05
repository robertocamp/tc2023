Using AWS Tags and Resource Groups
Introduction
To simplify the management of AWS resources such as EC2 instances, you can assign metadata using tags. Resource groups can then use these tags to automate tasks on large numbers of resources at one time. They serve as a unique identifier for custom automation, to break out cost reporting by department and much more. In this hands-on lab, we will explore tag restrictions and best practices for tagging strategies. We will also get experience with the Tag Editor, AWS resource group basics, and leveraging automation through the use of tags.

Solution
Log in to the live AWS environment using the credentials provided. Make sure you're in the N. Virginia (us-east-1) Region throughout the lab.

Set Up AWS Config
Navigate to Config.
In the Set up AWS Config window, click 1-click setup.
Leave the settings as their defaults.
Click Confirm.
Tag an AMI and EC2 Instance
In a new browser tab, navigate to EC2 > Instances (running).
Select any of the instances listed.
Right-click on the name of the selected instance, and select Actions > Image and templates > Create image.
For the Image name, enter Base.
Click Create image.
Click AMIs in the left-hand menu.
Once the AMI you just created has a status of available, select it. (It could take 5–15 minutes.)
Click Launch instance from AMI.
For Name, enter My Test Server.
For Instance type, select t3.micro.
For Key pair name, select Proceed without a key pair (Not recommended).
In the Network settings section, under Firewall (security groups), choose Select existing security group.
Under Common security groups, select the one with SecurityGroupWeb in the name (not the default security group).
Leave the rest of the default settings.
Click Launch instance.
Click View all instances, and give it a few minutes to enter the running state.
Tag Applications with the Tag Editor
Module 1 Tagging
In a new browser tab, navigate to Resource Groups & Tag Editor.
Click Tag Editor in the left-hand menu.
In the Find resources to tag section, set the following values:
Regions: Select us-east-1. (It should already be selected.)
Resource types:
Enter and select AWS::EC2::Instance.
Enter and select AWS::S3::Bucket.
Click Search resources.
In the Resource search results section, set the following values:
In the Filter resources search window, enter Mod. 1 and press Enter to execute the search.
Select both instances, and click Clear filters.
In the Filter resources search window, enter moduleone, and press Enter.
Select the listed S3 bucket, and click Clear filters.
Click Manage tags of selected resources.
In the Edit tags of all selected resources section, click Add tag, and set the following values:
Tag key: Enter Module.
Tag value: Enter Starship Monitor.
Click Review and apply tag changes > Apply changes to all selected.
Module 2 Tagging
With the same Region and resource types selected from the prevoius step, click Search resources again.
In the Resource search results section, set the following values:
In the Filter resources search window, enter Mod. 2, and press Enter.
Select both instances, and click Clear filters.
In the Filter resources search window, enter moduletwo, and press Enter.
Select the listed S3 bucket, and click Clear filters.
Click Manage tags of selected resources.
In the Edit tags of all selected resources section, click Add tag, and set the following values:
Tag key: Enter Module.
Tag value: Enter Warp Drive.
Click Review and apply tag changes > Apply changes to all selected.
Create Resource Groups and Use AWS Config Rules for Compliance
Create the Starship Monitor Resource Group
In the left-hand menu, select Create Resource Group.
For Group type, select Tag based.
In the Grouping criteria section, All supported resource types should already be selected.
In the Tags field, select the following:
Tag key: Select Module.
Optional tag value: Select Starship Monitor.
Click Preview group resources.
Ensure the three group resources show up in the Group resources section.
In the Group details section, enter a Group name of Starship-Monitor.
Click Create group.
Create the Warp Drive Resource Group
In the left-hand menu, click Create Resource Group.
For Group type, select Tag based.
In the Grouping criteria section, All supported resource types should still be selected.
In the Tags field, select the following:
Tag key: Select Module.
Optional tag value: Select Warp Drive.
Click Preview group resources.
Ensure the three group resources show up in the Group resources section.
In the Group details section, enter a Group name of Warp-Drive.
Click Create group.
View the Saved Resource Groups
In the left-hand menu, click Saved Resource Groups.
Click Starship-Monitor.
Here, we should see all the resources in our Starship-Monitor group.
Use AWS Config Rules for Compliance
Navigate back to the EC2 browser tab.
Refresh the instances table.
Select the My Test Server instance.
In the Details section, copy its AMI ID.
Navigate to the AWS Config console tab.
In the left-hand menu, click Rules.
Click Add rule.
For the rule type, select Add AWS managed rule.
Search for approved-amis-by-id in the search box, and select that rule.
Click Next.
In the Parameters section, paste the AMI ID you just copied into the Value field.
Click Next > Add rule.
Back in the EC2 instances console, select all the instances.
Click Instance state > Reboot instance.
In the Reboot instances? dialog, click Reboot.
Navigate back to the AWS Config Console.
After a few minutes, refresh the page.
You should see there are now noncompliant resources.
Click the approved-amis-by-id rule.
Choose one of the noncompliant resource IDs, and remember its last four characters.
Back in the EC2 console, identify the instance (by matching the last four characters), and then select it.
In the Details section, identify its AMI ID.
Back in the AWS Config console, identify the AMI ID under Value in the Parameters section.
You should see it doesn't match the AMI ID you noted in EC2, which means the rule successfully identified noncompliant resources.
