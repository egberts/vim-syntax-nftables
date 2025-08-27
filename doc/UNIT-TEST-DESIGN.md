# Unit Test Design
## Overview
The unit test design for the Vim syntax file `nftables.vim` is 
a critical step in ensuring the syntax file is accurate and 
reliable. This document outlines the design process, including 
the test cases, the test framework, and the expected outcomes.

### Directory Laytout
We have two major directories that pertains to unit test environments:

* Passive Environment
* Active Environment

Given that we also focus on 4-state true/false positive/negative 
outcome, subdirectories are made to reflect each state.

And the `corpus/` subdirectory contains all the `nftables` 
script files in which is being tested by 
the `vim-syntax-nftables` Vim syntax highlighter for Nftables.  

```console
   vim-syntax-nftables/
       vim/
           autocmd/
           ftdetect/
           ftplugin/
           scripts/
           syntax/
           tests/
       tests/
           corpus/
               base_cmd/
                   add_cmd/
               stmt/
           passive/
           active/
```

## Test Cases
### Overview

### 1. Installation
#### `make`
Makefile provides for:

* `install` - installation into `~/.vim/syntax`, et al.
* `check` - performs basic syntax checking of valid nft script files
* `test` - exercises unit test files(s)
* `remove` - remove installation of `vim-syntax-nftables` from `~/.vim/*`.

### 2. Basic Syntax
#### Test Case 1.1: Basic Structure
#### Test Case 1.2: Basic Statement
#### Test Case 1.3: Basic Comment
#### Test Case 1.4: Basic Keyword
#### Test Case 1.5: Basic Identifier
### 3. Passive Environment
Unit tests in passive test environment do everything they can 
without making a change to the network firewall (`nftables`) 
rules inside the Linux kernel; it may do some polling of data 
from the kernel but no write change capability.

#### Test Case 2.1: Complex Statement
#### Test Case 2.2: Complex Comment
#### Test Case 2.3: Complex Keyword

### 4. Active Environment
Unit tests in active environment entails the actual 
modification and exercise of network rules inside the 
Linux kernel.

This is an important step to ensure actual working unit 
test cases that a simple static syntax checker (`nft -c`)
cannot perform.

    


    