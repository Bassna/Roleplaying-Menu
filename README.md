# Roleplaying Menu

<div align="center">
  <img src="https://github.com/user-attachments/assets/44cb794e-dfe4-40b6-ae84-817a517e2fd3" alt="RoleplayingMenuIcon-9" width="200">
</div>



Welcome to the **Roleplaying Menu**! This menu is your all-in-one tool for managing and executing your favorite RP lines, commands, and much more. Whether you're organizing your RP collection, setting up custom presets, or using advanced features like math variables, the Roleplaying Menu streamlines your roleplaying experience across various games.

<details>
  <summary><strong>⭐ Features</strong></summary>
  
  The Roleplaying Menu offers a comprehensive set of features designed to enhance your roleplaying sessions:
  
  - **Manage Your Roleplay Collection**
    - **Add**, **Edit**, or **Delete** Roleplay lines or Categories with ease.
    - **Search**: Quickly locate any RP line or category using the search bar.
    - **Display Settings**: Customize the transparency and size of the app to fit your preferences.
    - Organize your entire Roleplay collection effortlessly.
  
  - **Random Playback**
    - Engage in single or consecutive random category RP line playback for a fresh experience every time.
  
  - **Custom Presets**
    - Create and save presets to run specific RP lines or random categories in sequence.
    - Modify your RP library within presets, adding, editing, or deleting RP lines as needed.
  
  - **Testing Mode**
    - Preview how RP lines will be sent without actually sending them to the target application.
    - View RP lines in a separate testing window before use, ensuring accuracy.
  
  - **Special Variables**
    - Use special variables like `{TodaysDate}`, `{RandomNumber}`, or `{FormatNumbers}` to dynamically insert information or perform calculations within your RP lines.
    - Include **List Variables** that provide dropdown choices for easy selection during RP execution.
  
  - **Advanced Math Operations**
    - Perform calculations directly within your RP lines, using symbols like `+`, `-`, `*`, `/`, and `%`.
    - Save and reuse calculation results for more complex scripts.
   
    ![MainExample01](https://github.com/user-attachments/assets/e72d3712-da10-4a28-b9f9-4836523ebe70)

</details>

<details>
  <summary><strong>🚀 Getting Started</strong></summary>
  
  Here's a quick guide to get you started:
  
  1. **Download & Run**
     - **Option A**: Download and launch `RoleplayingMenu.AHK`. This requires AutoHotKey v1.1 if you do not have it already.
     - **Option B**: If you prefer not to use AutoHotKey, you can run `RoleplayingMenu.exe` found in the OPTIONAL folder. This executable offers the same experience tailored without AutoHotKey.
  
  2. **Accessing the Menu**
     - Launch the application and press `F5` to toggle the Roleplaying Menu open or closed.
  
  3. **Setting Up Your RP Lines**
     - Select 'Edit RP' to customize the Roleplay categories and lines to your own.
     - A file named `RPLines.txt` will be automatically created on your first run. This file stores your RP lines and categories and is stored next to your AHK file.
</details>

<details>
  <summary><strong>🎛️ Hotkeys </strong></summary>
  
  Navigate the Roleplaying Menu with these hotkeys:
  
  - `F5`: **Open the Main Roleplaying Menu**. Toggle the menu open or closed.
  - `SHIFT + F5`: **Toggle between Full Size and Compact size menus**.
  - `CTRL + F5`: **Open the Random RP Menu directly**.
  - `ALT + F5`: **Open the Preset Menu directly**.
  - `F11`: **Pause the script and any current typing**. Press again to resume.
  - `F12`: **Stop and completely close the Roleplay Menu script**.
</details>

<details>
  <summary><strong>🔧 Custom Variables</strong></summary>
  
  The **Custom Variables** feature allows you to create dynamic RP lines by enclosing any word or phrase in curly brackets `{}`. Each word or phrase inside the brackets becomes a custom variable. When the RP line is executed, a pop-up window will appear, prompting you to fill in the custom variables.
  
  **How Custom Variables Work**:
  
  1. **Defining Custom Variables**
     - Simply include a word or phrase inside curly brackets `{}` in your RP line. For example: `{BLS Kit Item}` or `{Raffle Ticket Amount}`.
  
  2. **Running RP Lines with Custom Variables**
     - When you run an RP line containing custom variables, a pop-up window will open, showing each custom variable with an input box. Once you fill in the boxes, the program will replace the variables with your input, and the completed line will be sent.
  
  3. **Multiple Custom Variables**
     - You can include multiple custom variables in a single RP line. The pop-up window will display input boxes for all variables, allowing you to fill them out all at once.
  
  **Example Usage**:
  
  - **Single Custom Variable**:  
    `/me pulls out a {BLS Kit Item} from the BLS kit.`  
    *When run, you'll be prompted to input the BLS Kit Item. For example, if you type "bandage," the final line will be `/me pulls out a bandage from the BLS kit.`*
  
  - **Multiple Custom Variables**:  
    `/me arrives at {Location}, looking for {Item}.`  
    *When run, you'll be prompted for both "Location" and "Item." If you input "the park" and "a bench," the final line will be `/me arrives at the park, looking for a bench.`*
</details>

<details>
  <summary><strong>📋 Presets</strong></summary>
  
  The **Presets** feature in the Roleplaying Menu allows you to create, save, and execute sequences of RP lines, providing structure and flexibility to your roleplaying sessions. Whether you want specific lines or random lines from selected categories, presets make it easy to streamline complex roleplay scenarios.
  
  **Using the Preset Menu**
  
  1. **Creating a New Preset**
     - Open the Preset Menu and select "Create New Preset." You can give your preset a name, select it, and add RP lines to run in sequence.
  
  2. **Adding RP Lines**
     - You can add RP lines in two ways:
       - **Specific Lines**: Select an RP line from your library by clicking "Add RP Line" and then "Select From Categories".
       - **Random Lines from Categories**: To add a random line from a category, select the category name instead of a line when adding. This will add `RandomFrom: [Category]` to your preset, selecting a random line from that category in the sequence.
  
  3. **Running a Preset**
     - To activate a preset, open the Preset Menu, select your desired preset, and click "Run Preset." This will execute each line in the sequence.
  
  **Example Usage**
  
  - **Single Preset Example**:
    - Create a preset named "Introduction" with specific lines such as `/me smiles warmly` and `Hello everyone!` You can also add a line like `RandomFrom: [Greetings]` to include a random greeting for added spontaneity.
  
  - **Complex Preset Example**:
    - Set up a preset called "Morning Routine," which includes lines like `RandomFrom: [Morning Greetings]`, `/me stretches and yawns`, and `Time for coffee!` This way, you can have a unique sequence for each use while maintaining a familiar routine.
  
  **Floating Preset Buttons**
  
  For quick access, create a **Floating Preset Button** by selecting the preset and clicking "Floating Preset Button" in the Preset Menu. This button can be moved around your screen, enabling you to run the preset at any moment with a simple click, without needing to reopen the Preset Menu.

Presets Example:
  ![PresetRPExample01](https://github.com/user-attachments/assets/7b8694fc-4a6d-4f31-908d-116d39f594cf)
  
Floating Preset Buttons Example:
  ![FloatingButtonExample01](https://github.com/user-attachments/assets/f500fa35-0bd8-49bd-a32e-97089c43eeb9)
</details>

<details>
  <summary><strong>🎲 Random RP</strong></summary>
  
  The **Random RP** feature allows you to dynamically engage with your roleplaying lines by selecting categories and running a random line from each in order. This keeps your interactions fresh and varied, adding spontaneity to each roleplaying session.
  
  **Using the Random RP Menu**
  
  1. **Opening the Random RP Menu**
     - Access the Random RP menu from the main interface to get started.
  
  2. **Selecting Categories**
     - In the Random RP menu, choose one or multiple categories. These categories contain your predefined RP lines.
  
  3. **Submitting Your Choices**
     - After selecting the categories, click "Submit." The program will then pull a random line from each selected category and run those lines in sequence.
  
  **Example Usage**
  
  - **Single Category**:
    - If you select a single category like "Greetings" and submit, it will choose a random RP line from the "Greetings" category and run it.
  
  - **Multiple Categories**:
    - If you select multiple categories such as "Greetings," "Introductions," and "Farewells" and submit, it will run a random line from each in order, adding variety to your interaction.
  
  Using the Random RP feature adds excitement and unpredictability to your roleplaying sessions, making each interaction feel unique and engaging.

  ![RandomRPExample01](https://github.com/user-attachments/assets/ba8e81c1-f13d-4ced-8cd9-8834d00e7156)
  



</details>

<details>
  <summary><strong>🔑 Special Variables</strong></summary>
  
  Use these **Special Variables** in your RP lines to dynamically insert specific information or perform calculations:
  
  1. `{TodaysDate}`
     - **Example**: `/me fills out the report with the date {TodaysDate}.`
     - **Result**: `/me fills out the report with the date September 10, 2024.`
  
  2. `{UTCDateTime}`
     - **Example**: `/me notes the time of the event as {UTCDateTime} UTC.`
     - **Result**: `/me notes the time of the event as 00:12 11/SEP.`
  
  3. `{NumberOfWeeksFromToday}`
     - **Example**: `/me schedules the follow-up meeting for {NumberOfWeeksFromToday} weeks from today.`
     - **Result**: `/me schedules the follow-up meeting for September 10, 2024.`
  
  4. `{RandomNumber}`
     - **Example**: `/me rolls a dice and gets a {RandomNumber}.`
     - **Result**: `/me rolls a dice and gets a 42.`
  
  5. `{DoNotEnter}`
     - Prevents the app from automatically pressing the Enter key after the RP line.
  
  6. `{SendInstantly}`
     - Sends the typing instantly, instead of typing out slowly.
  
  7. `{SkipChatOpen}`
     - Skips opening the chat before sending commands.
     - **Example**: `/cinemaaddqueue https://www.youtube.com/watch?v=Dt3riT2cH5U {SkipChatOpen}`
     - **Result**: `/cinemaaddqueue https://www.youtube.com/watch?v=Dt3riT2cH5U`
  
  8. `{Comment=}`
     - Allows you to add a comment that wonâ€™t be sent with the command.
     - **Example**: `{Comment=Arcadius Commercial} /cinemaaddqueue https://www.youtube.com/watch?v=Dt3riT2cH5U`
     - **Result**: `/cinemaaddqueue https://www.youtube.com/watch?v=Dt3riT2cH5U`
  
  9. `{FormatNumbers}`
     - Automatically adds commas as thousand separators to all numbers in the line.
     - **Example**: `The total cost is $3502253 {FormatNumbers}`
     - **Result**: `The total cost is $3,502,253`
  
  10. `{RoundNumbers}`
      - Automatically rounds all numbers in the line to the nearest whole number.
      - **Example**: `The total cost is $253.69 {RoundNumbers}`
      - **Result**: `The total cost is $254`
  
  11. `{Loop}`
      - **Example**: `Burger. {Loop} {DoNotEnter}`
      - **User Input**: `5`
      - **Result**: `Burger. Burger. Burger. Burger. Burger.`
      - **Note**: The `{Loop}` variable allows you to specify how many times a line should repeat.
  
  12. `{List: Option1, Option2(25), Option3}`
      - Creates a dropdown list of options with optional outputs in parentheses or a range.
      - **Example**: `/me chooses an option from the list: {List: LSC, LSPD, Bayview}.`
        - **Result**: `/me chooses an option from the list: LSC.`
      - **Example**: `/me chooses an option from the list: {List: LSC(25), LSPD(50), Bayview(75)}.`
        - **Result**: `/me chooses an option from the list: 25.`
      - **Example**: `/me selects a number from the range: {List: Number <1-10>}.`
        - **Result**: `/me selects a number from the range: 5.` *(A dropdown with numbers 1 through 10 is created.)*
      - **Notes**:
        - Use the `<start-end>` syntax to create a range-based dropdown (e.g., `<1-10>` or `<0.1-1>` for decimal ranges).
        - You can include optional outputs in parentheses for each item in the list.
        - Matching list variables will combine into one dropdown menu.
  
  13. `{Slider: Option1, Option2(25), Option3}`
      - Creates a dropdown slider of options with optional outputs in parentheses or a range.
      - **Example**: `/me chooses an option from the slider: {Slider: LSC, LSPD, Bayview}.`
        - **Result**: `/me chooses an option from the slider: LSC.`
      - **Example**: `/me chooses an option from the slider: {Slider: LSC(25), LSPD(50), Bayview(75)}.`
        - **Result**: `/me chooses an option from the slider: 25.`
      - **Example**: `/me selects a number from the range: {Slider: Number <1-10>}.`
        - **Result**: `/me selects a number from the range: 5.` *(A dropdown with numbers 1 through 10 is created.)*
      - **Notes**:
        - Use the `<start-end>` syntax to create a range-based dropdown (e.g., `<1-10>` or `<0.1-1>` for decimal ranges).
        - You can include optional outputs in parentheses for each item in the slider.
        - Matching slider variables will combine into one dropdown menu.
</details>

<details>
  <summary><strong>➕ Advanced Math Operations</strong></summary>
  
  **Advanced Math Operations** allow you to perform calculations directly within your RP lines. These operations follow basic mathematical rules and are processed in sequence from left to right. Custom and Special variables can be used inside of the math operations for on-the-fly inputs. 

Calculated results can be stored in placeholders such as {MathOutput1}, {MathOutput2}, and so forth, allowing you to reuse these values in other RP lines.
  
  **Supported Symbols**:
  - `+` (Addition)
  - `-` (Subtraction)
  - `*` or `x` (Multiplication)
  - `/` (Division)
  - `%` (Percentage)
  - `@` (Average)
  
  **Example Usage**:
  
  - **Basic Addition and Multiplication**:  
    `{{ {Number1} + {Number2} }}`  
    *If Number1 = 10 and Number2 = 5, the result will be 15.*
  
  - **Combined Operations**:  
    `{{ {Number1} * {Number2} + {Number3} / {Number4} }}`  
    *If Number1 = 2, Number2 = 10, Number3 = 20, and Number4 = 5, the result will be 8.*
  
  - **Sequence-Dependent Calculation**:  
    `{{ {Number1} + {Number2} - {Number3} / {Number4} }}`  
    *If Number1 = 10, Number2 = 5, Number3 = 10, and Number4 = 2, the result will be 12.5.*

  - **Using Placeholders**:  
    Store the result of a calculation in `{MathOutput1}` for later use:  
    `{{ {Number1} + {Number2} = {MathOutput1} }}`  
    *If Number1 = 10 and Number2 = 20, `{MathOutput1}` will store the result 30.*  
    You can then reuse `{MathOutput1}` in another line, such as:  
    `/me calculates the total as {MathOutput1}.`
</details>

<details>
  <summary><strong>🛑 Emergency Stop Feature</strong></summary>
  
  For quick control, several keys (`F1-F10`, `Windows`, `Alt`, `Tab`, `Backspace`, `Escape`, `Enter`) instantly halt ongoing RP line typing, ensuring you maintain full control.
</details>

---

Enjoy your Roleplay with the **Roleplaying Menu**!
