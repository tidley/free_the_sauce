# OpenSauce

## Team Members
tidley

## Tool Description
Smartphone app enabling free and anonymous distribution of immutable GPS-linked data.

Centralised control of data sharing are removed throughout this software stack.

### Pro-Social Technology
Users of this FOSS (Free and Open Source Software) application can securely archive data using a decentralised storage network called IPFS (**I**nter**P**lanetary **F**ile**S**ystem).

### Accessible
Data can be any file(s) on the smartphone including photos, videos and audio. Once uploaded to IPFS these files are referenced using a unique, immutable link called a **C**ontent-**ID**entifier, or **CID**. 

Several anonymous gateways can be used to retrieve the data using just the CID, e.g. https://w3s.link/ipfs/bafkreidivzimqfqtoqxkrpge6bjyhlvxqs3rhe73owtmdulaxr5do5in7u

### Immutable and Tamper-Resistant
There is no method to delete data from the network once it's uploaded, and the more it's accessed the more the data are made available via nodes on the IPFS network.

The CID used to retrieve the data is a fingerprint, sha-256 hash of the contents in base32 format, meaning the data cannot be altered without changing the CID.

### Flexible
Upload time and GPS co-ordinates are included as metadata and other fields can be easily added.

### Alternatives
https://anonfiles.com/
    - link returned is not fingerprint of file
    - Data stored in a centralised fashion
https://gofile.io/welcome
    - link returned is not fingerprint of file
    - Data stored in a centralised fashion
https://mega.nz/
    - link returned is not fingerprint of file
    - Data stored in a centralised fashion
https://transferfile.io/
    - Most relevant
    - No API
    https://www.transferfile.io/#/bafybeicvcnjuhvh6jlfzf6lxuniwfhe26nvfo3orrzerodlxw3t7do3x5a
https://mnemonic.org/
    - Nice verification steps but paid-for
- Read text from images on centralised photo-sharing sites: https://imgur.com/a/RKR3S76
    - Impractical

### Requirements
- API after free registration at https://web3.storage/login/
    > Github handle / e-mail not required after sign-up so disposable identities can be used.

- Download data from w3s.link/ipfs/**CID**
- Verify source using GPS and time metadata
- Increased transparency.

This sections discusses the purpose and motivation for the tool, and how it addresses a tool need you've identified.

## Installation
1. Download apk from the repo

## Usage
This sections includes detailed instructions for using the tool. If the tool has a command-line interface, include common commands and arguments, and some examples of commands and a description of the expected output. If the tool has a graphical user interface or a browser interface, include screenshots and describe a common workflow.

## Additional Information
This section includes any additional information that you want to mention about the tool, including:
- Potential next steps for the tool (i.e. what you would implement if you had more time)
- Any limitations of the current implementation of the tool
- Motivation for design/architecture decisions
### Challenges

## Goals
### Bellingcat integration
- Each time data are uploaded the CID can be sent to an endpoint at Bellingcat (e.g. https://www.bellingcat.com/resources/2022/09/22/preserve-vital-online-content-with-bellingcats-auto-archiver-tool/).
- Bellingcat can introduce an automated verification scheme à la https://mnemonic.org/
- >100MB uploads
---

Demo
https://youtu.be/LCmZ06Z5dgk