const fs = require('fs').promises;
const path = require('path');

const enviarCorreoConfirmacionReserva = async ({
  transporter,
  nombre,
  email,
  telefono,
  fecha_reserva,
  cantidad,
  modalidad,
  metodo_pago,
  punto_encuentro,
  peticiones_especiales,
  total,
  reserva_codigo
}) => {
  try {
    const templatePath = path.join(__dirname, '../views/emails/confirmacion_reserva.html');
    let htmlTemplate = await fs.readFile(templatePath, 'utf-8');

    // Sustituir los valores fijos
    htmlTemplate = htmlTemplate
      .replace('{{nombre}}', nombre)
      .replace('{{reserva_codigo}}', reserva_codigo)
      .replace('{{fecha_reserva}}', fecha_reserva)
      .replace('{{modalidad}}', modalidad)
      .replace('{{cantidad}}', cantidad)
      .replace('{{total}}', total)
      .replace('{{metodo_pago}}', metodo_pago)
      .replace('{{email_contacto}}', process.env.EMAIL_CONTACTO);

    // Inserción condicional
    const puntoEncuentroHtml = punto_encuentro
      ? `<li><strong>Punto de encuentro:</strong> ${punto_encuentro}</li>`
      : '';
    const peticionesHtml = peticiones_especiales
      ? `<li><strong>Peticiones especiales:</strong> ${peticiones_especiales}</li>`
      : '';

    htmlTemplate = htmlTemplate
      .replace('{{punto_encuentro_block}}', puntoEncuentroHtml)
      .replace('{{peticiones_especiales_block}}', peticionesHtml);

    const mailOptions = {
      from: `"Riviera Tours" <${process.env.EMAIL_FROM}>`,
      to: email,
      subject: `Tu reserva ha sido registrada: ${reserva_codigo}`,
      html: htmlTemplate,
    };

    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error('Error al enviar correo de confirmación de reserva:', error);
    throw error;
  }
};

const enviarCorreoConfirmacionPago = async (transporter, reserva, tour) => {
  try {
    const templatePath = path.join(__dirname, '../views/emails/confirmacion_pago.html');
    let htmlTemplate = await fs.readFile(templatePath, 'utf-8');

    // Reemplazo de variables en el HTML
    htmlTemplate = htmlTemplate
      .replace('{{nombre_cliente}}', reserva.nombre_cliente)
      .replace('{{reserva_codigo}}', reserva.reserva_codigo)
      .replace('{{nombre_tour}}', tour.nombre)
      .replace('{{fecha_reserva}}', reserva.fecha_reserva)
      .replace('{{cantidad_personas}}', reserva.cantidad_personas)
      .replace('{{total_pagado}}', reserva.total_pagado);

    const mailOptions = {
      from: `"Tours Riviera" <no-reply@toursriviera.com>`,
      to: reserva.email,
      subject: '¡Pago recibido! Confirmación de tu reserva',
      html: htmlTemplate,
    };

    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error('Error al enviar correo de confirmación de pago:', error);
    throw error;
  }
};

module.exports = {
  enviarCorreoConfirmacionReserva, enviarCorreoConfirmacionPago,
};

