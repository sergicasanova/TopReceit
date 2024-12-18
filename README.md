# **TopReceit - Proyecto Final 2º DAM**

## **Descripción del Proyecto**
**TopReceit** es una aplicación web de gestión de recetas y usuarios, donde los usuarios pueden crear, modificar y visualizar sus recetas favoritas, así como interactuar con otros usuarios a través de un sistema de login y registro.

Este proyecto está desarrollado como parte del proyecto final de **2º DAM (Desarrollo de Aplicaciones Multiplataforma)** y combina tanto tecnologías **frontend** como **backend**.

---

## **Tecnologías Utilizadas**

### **Frontend**
- **Flutter**: Framework de desarrollo multiplataforma para crear interfaces de usuario dinámicas y nativas.
- **GoRouter**: Librería para la gestión de rutas en Flutter.
- **BLoC Pattern**: Gestión del estado utilizando el patrón **BLoC** (Business Logic Component).
- **SharedPreferences**: Almacenamiento local para guardar los datos del usuario (por ejemplo, email) entre sesiones.

### **Backend**
- **NestJS**: Framework de Node.js basado en **TypeScript** para construir aplicaciones escalables del lado del servidor.
- **JWT**: Autenticación de usuarios utilizando **JSON Web Tokens** para manejar las sesiones de los usuarios.

---

## **Funcionalidades**

### **Frontend**
- **Login/Registro de Usuarios**: Los usuarios pueden registrarse con su email, nombre de usuario, y otros detalles, o iniciar sesión con su cuenta.
- **Gestión de Recetas**: Los usuarios pueden crear, modificar y eliminar recetas desde la interfaz.
- **Visualización de Recetas**: Los usuarios pueden ver las recetas creadas por otros usuarios.
- **Cambio de Fondo**: Opción de personalizar el fondo de la interfaz utilizando imágenes almacenadas localmente.

### **Backend**
- **Autenticación de Usuarios**: Implementación de login y registro utilizando **JWT** para gestionar las sesiones.
- **CRUD de Recetas**: API RESTful para la creación, lectura, actualización y eliminación de recetas.
- **Gestión de Usuarios**: API para manejar los datos de los usuarios, incluyendo la modificación de sus detalles.

---

## **Instalación y Configuración**

### **Requisitos Previos**
- [Flutter](https://flutter.dev/docs/get-started/install)
- [NestJS CLI](https://docs.nestjs.com/)


