# 🖥️ Virtualization & Clustering

This module provides enterprise-level management for Hyper-V Failover Clusters. These scripts focus on automated provisioning, resource optimization, and ensuring high availability for critical virtual workloads.

## 📋 Scripts Included

### 1. New-ClusteredVM.ps1
* **Purpose:** Automates the end-to-end deployment of Highly Available (HA) Virtual Machines.
* **Value:** Standardizes VM configurations (vCPU, RAM, VLANs) and ensures they are correctly registered within the Failover Cluster for automatic failover.

### 2. Get-VMResourceReport.ps1
* **Purpose:** Audits CPU, RAM, and Disk allocation across all running guests.
* **Value:** Identifies "Zombie VMs" and over-provisioned resources, allowing for data-driven hardware density improvements and cost savings.

### 3. Invoke-VMLiveMigration.ps1
* **Purpose:** Orchestrates the bulk movement of VMs between cluster nodes.
* **Value:** Critical for "Zero-Downtime" maintenance; allows an administrator to empty a physical host of all workloads for patching or hardware repair with one command.

### 4. Test-VMReplicationHealth.ps1
* **Purpose:** Monitors Hyper-V Replica status and synchronization latency.
* **Value:** Ensures the Disaster Recovery (DR) site is ready at all times. Flags replication failures before they become a "Point-in-Time" data loss risk.

### 5. Optimize-VHDXSize.ps1
* **Purpose:** Mounts and compacts dynamic virtual hard disks (VHDX).
* **Value:** Reclaims gigabytes of physical host storage by shrinking virtual disks that have deleted internal data, extending the life of existing hardware.

### 6. Get-OrphanedVirtualDisks.ps1
* **Purpose:** Scans Cluster Shared Volumes (CSVs) for VHDX files not attached to any VM.
* **Value:** Finds "Ghost Storage"—disks left behind by deleted VMs—that is often the #1 cause of "Unknown" storage exhaustion.

## ⚙️ Requirements
* **Hyper-V Module** and **FailoverClusters Module** (RSAT) must be installed.
* Must be executed with Local Administrator and Cluster permissions.
