Execute a synchronous Azure PowerShell cmdlet in asynchronous fashion
=====================================================================

            

Synchronous operations in PowerShell can significantly slow down a scripted deployment, and the purpose of this post is to help Azure customers script synchronous cmdlets in multiple threads within a single PowerShell session to speed up deployment times.


The example we will demonstrate is the creation of PublicIpAddress resources in Azure Resource Manager (ARM). The cmdlet used is: New-AzureRmPublicIpAddress.


 


 



        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
