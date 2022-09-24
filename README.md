# OpenSauce

## Team Members
tidley

## Tool Description
Smartphone app enabling immutable, free and anonymous distribution of GPS-linked data.

### Pro-Social Technology
Users of this FOSS (Free and Open Source Software) application can securely archive data using a decentralised storage network called IPFS (**I**nter**P**lanetary **F**ile**S**ystem).

### Easy Access
Data can be any file(s) on the smartphone including photos, videos and audio. Once uploaded to IPFS these files are referenced using a unique, immutable link called a **C**ontent-**ID**entifier, or **CID**. 

Several anonymous gateways can be used to retrieve the data using just the CID, e.g. https://w3s.link/ipfs/bafkreidivzimqfqtoqxkrpge6bjyhlvxqs3rhe73owtmdulaxr5do5in7u

### Immutable and Tamper-proof
There is no method to delete data from the network once it's uploaded, and the more it's accessed the more the data are made available via nodes on the IPFS network.

The CID used to retrieve the data is a fingerprint, sha-256 hash of the contents in base32 format, meaning the data cannot be altered without changing the CID.

### Alternatives
Read text from images on centralised photo-sharing sites: https://imgur.com/a/RKR3S76
    - These can be 

### Requirements
- API after free registration at https://web3.storage/login/
    > Github handle / e-mail not required after sign-up so disposable identities can be used.

Purpose:
Free sharing of data.
### From Source

### From Researcher
- Read data from ipfs.io/ipfs...
- Download, verify source
    - Source verifiable using hash of data
        - in block?
        - in BTC tx?
        - 
    - Source verifiable with GPS data and date

- Increased transparency.


This sections discusses the purpose and motivation for the tool, and how it addresses a tool need you've identified.

## Installation
This section includes detailed instructions for installing the tool, including any terminal commands that need to be executed and dependencies that need to be installed. Instructions should be understandable by non-technical users (e.g. someone who knows how to open a terminal and run commands, but isn't necessarily a programmer), for example:

1. Make sure you have Python version 3.8 or greater installed

2. Download the tool's repository using the command:

        git clone https://github.com/bellingcat/hackathon-submission-template.git

3. Move to the tool's directory and install the tool

        cd hackathon-submission-template
        pip install .

## Usage
This sections includes detailed instructions for using the tool. If the tool has a command-line interface, include common commands and arguments, and some examples of commands and a description of the expected output. If the tool has a graphical user interface or a browser interface, include screenshots and describe a common workflow.

## Additional Information
This section includes any additional information that you want to mention about the tool, including:
- Potential next steps for the tool (i.e. what you would implement if you had more time)
- Any limitations of the current implementation of the tool
- Motivation for design/architecture decisions
### Challenges

## Goals
### Bellingcat integertion
- Each time data are uploaded the CID can be sent to an endpoint at Bellingcat (e.g. https://www.bellingcat.com/resources/2022/09/22/preserve-vital-online-content-with-bellingcats-auto-archiver-tool/).
- Bellingcat can introduce an automated verification scheme à la https://mnemonic.org/
- >100MB uploads
---
# Connect the World
Let data be free.

Short demo
https://youtu.be/8j7Ij9uSK20

## Todo
1. Qr scan for nft.storage key
1. Add 'Share all' buttons
1. Read from smart contract to get IP address/Tor address of Lightning node 


https://github.com/xclud/web3dart/blob/development/example/contracts.dart
https://lightning.readthedocs.io/lightning-getinfo.7.html 


1. Add dividers in layout https://www.woolha.com/tutorials/flutter-using-divider-and-verticaldivider-widgets-examples

1. https://riverpod.dev/docs/providers/future_provider

## Requirements
1. To remove warning on debug startup edit line 275 in\
 __/home/tom/.pub-cache/hosted/pub.dartlang.org/flutter_riverpod-1.0.3/lib/src/framework.dart__\
`if (SchedulerBinding.instance!.schedulerPhase ==`\
to\
`if (SchedulerBinding.instance.schedulerPhase ==`

## Resources
Share
https://www.digitalocean.com/community/tutorials/flutter-share-plugin
FutureBuilder
https://flutterigniter.com/build-widget-with-async-method-call/
Rebuilds
https://flutterigniter.com/future-async-called-multiple-times/

