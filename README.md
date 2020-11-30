# Terraform + AWS + Django & React

La estructura del proyecto está seccionada por módulos:

- Main
- VPC
- Django
- React

Cada módulo cuenta con sus respectivos archivos y configuración Terraform.

## Módulo main:

Es la torre de control de la plantilla, ejecuta los modulos VPC, instancias Frontend y Backend, con sus respectivas aplicaciones.

Aplicar `terraform init` `terraform apply` únicamente en la raíz del proyecto,  es decir, sobre el módulo main.

## Módulo VPC

Módulo encargado de aprovisionar la VPC y sus configuraciones.

## Módulo React y Django

Estos módulos están organizados en la carpeta instancias. Las instancias EC2, en este caso, React y Django, cuenta con sus archivos y configuración de terraform como módulos independientes.



