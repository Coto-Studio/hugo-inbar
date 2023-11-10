// Botpoison Form Integration, by Coto.Studio
// import("https://unpkg.com/@botpoison/browser");

// AJAX Form Submit
async function submitForm(event) {
  // Stop from submitting and stop default Botpoison script
  event.stopPropagation();
  event.preventDefault();

  // Vars.
  const form = event.target;
  const infoMessage = "Scanning for spam bots!<br />(Processing request)";
  const successMessage = "All set. Thank you!";
  const errorMessage = "Something went wrong... :(";
  const submit = form.querySelector("input[type='submit']");
  const formAction = form.getAttribute("action");
  const successURL = form.dataset.successUrl;
  const pubKey = form.dataset.botpoisonPublicKey;
  const botpoison = new Botpoison({
    publicKey: pubKey,
  });

  // Create Message Prompt.
  var message = document.createElement("span");
  message.classList.add("message");
  form.appendChild(message);

  message._show = function (type, text) {
    message.innerHTML = text;
    message.classList.add(type);
    message.classList.add("visible");
  };

  message._hide = function () {
    message.classList.remove("visible");
  };

  // Disable submit.
  submit.disabled = true;
  message._show("info", infoMessage);

  // Process form data.
  const formData = new FormData(form);
  const data = {};
  formData.forEach((value, key) => (data[key] = value));

  // Get Botpoison solution
  const { solution } = await botpoison.challenge({
    onProgress: (progress) => {
      if (progress === 1) return message._hide();
    },
  });
  data["_botpoison"] = solution;

  // Create Fetch request
  try {
    const response = await fetch(formAction, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify(data),
    });
    console.log(response);
    message._show("success", successMessage);

    // Reset form.
    form.reset();
  } catch (error) {
    console.error(error);
    message._show("error", errorMessage);
  }

  // Enable submit.
  submit.disabled = false;

  if (successURL) window.location.replace(successURL);
}

// Add eventListener to all forms
// Has to be added this way to override botpoison's document level eventListener
const forms = document.getElementsByTagName("form");
for (let form of forms) {
  form.addEventListener("submit", (e) => submitForm(e));
}