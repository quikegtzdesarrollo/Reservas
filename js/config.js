// Configuración para manejo de URLs en diferentes entornos
const CONFIG = {
  // Determinar si estamos en localhost o en producción
  isLocalhost: () => {
    return window.location.hostname === 'localhost' || 
           window.location.hostname === '127.0.0.1' ||
           window.location.hostname === '';
  },
  
  // Obtener la URL base del proyecto
  getBaseUrl: () => {
    if (CONFIG.isLocalhost()) {
      return window.location.origin;
    } else {
      return 'https://quikegtzdesarrollo.github.io/Reservas';
    }
  },
  
  // Obtener URL de redirección para autenticación
  getAuthRedirectUrl: () => {
    return `${CONFIG.getBaseUrl()}/menu.html`;
  },
  
  // Obtener URL para navegación entre páginas
  getPageUrl: (pageName) => {
    return `${CONFIG.getBaseUrl()}/${pageName}`;
  },
  
  // URLs específicas
  getIndexUrl: () => CONFIG.getPageUrl('index.html'),
  getMenuUrl: () => CONFIG.getPageUrl('menu.html'),
  getReservaUrl: () => CONFIG.getPageUrl('reserva.html'),
  getOrdenesUrl: () => CONFIG.getPageUrl('ordenes.html')
};

// Función helper para redirección
function redirectTo(pageName) {
  window.location.href = CONFIG.getPageUrl(pageName);
}

// Función helper para redirección a index
function redirectToIndex() {
  window.location.href = CONFIG.getIndexUrl();
}

// Función helper para redirección a menu
function redirectToMenu() {
  window.location.href = CONFIG.getMenuUrl();
} 