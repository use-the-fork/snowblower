### File Structure
src/snowblower_cli/                                                                                  
├── __init__.py                                                                                      
├── __main__.py                                                                                      
├── cli/                                                                                             
│   └── __init__.py                                                                                  
├── config/                                                                                          
│   ├── __init__.py                                                                                  
│   └── parser.py       # Parse snowblower.yml                                                       
├── generators/                                                                                      
│   ├── __init__.py                                                                                  
│   ├── languages/      # Handle language-specific configs                                           
│   │   ├── __init__.py                                                                              
│   │   ├── php/                                                                                     
│   │   │   ├── __init__.py                                                                          
│   │   │   ├── core.py                                                                              
│   │   │   └── tools/                                                                               
│   │   │       ├── __init__.py                                                                      
│   │   │       ├── composer.py                                                                      
│   │   │       └── pint.py                                                                          
│   │   ├── javascript/                                                                              
│   │   │   ├── __init__.py                                                                          
│   │   │   ├── core.py                                                                              
│   │   │   └── tools/                                                                               
│   │   │       ├── __init__.py                                                                      
│   │   │       ├── yarn.py                                                                          
│   │   │       └── prettier.py                                                                      
│   │   └── ...                                                                                      
│   ├── services/       # Handle service configurations                                              
│   │   ├── __init__.py                                                                              
│   │   ├── mysql.py                                                                                 
│   │   └── ...                                                                                      
│   └── shell/          # Handle shell tools                                                         
│       ├── __init__.py                                                                              
│       ├── zsh.py                                                                                   
│       ├── tools/                                                                                   
│       │   ├── __init__.py                                                                          
│       │   ├── git.py                                                                               
│       │   └── ...                                                                                  
│       └── ...                                                                                      
├── logger.py                                                                                        
└── utils.py

src/snowblower_container/flake/                                                                           
├── flake.nix                                                                                        
├── flake.lock                                                                                       
├── home/                                                                                            
│   ├── default.nix                                                                                  
│   ├── languages/                                                                                   
│   │   ├── default.nix                                                                              
│   │   ├── php/                                                                                     
│   │   │   ├── default.nix                                                                          
│   │   │   └── tools/                                                                               
│   │   │       ├── default.nix                                                                      
│   │   │       ├── composer.nix                                                                     
│   │   │       └── pint.nix                                                                         
│   │   ├── javascript/                                                                              
│   │   │   ├── default.nix                                                                          
│   │   │   └── tools/                                                                               
│   │   │       ├── default.nix                                                                      
│   │   │       ├── yarn.nix                                                                         
│   │   │       └── prettier.nix                                                                     
│   │   └── ...                                                                                      
│   ├── services/                                                                                    
│   │   ├── default.nix                                                                              
│   │   ├── mysql.nix                                                                                
│   │   └── ...                                                                                      
│   └── shell/                                                                                       
│       ├── default.nix                                                                              
│       ├── zsh/                                                                                     
│       │   ├── default.nix                                                                          
│       │   └── ...                                                                                  
│       └── tools/                                                                                   
│           ├── default.nix                                                                          
│           ├── git.nix                                                                              
│           └── ...                                                                                  
└── ...         